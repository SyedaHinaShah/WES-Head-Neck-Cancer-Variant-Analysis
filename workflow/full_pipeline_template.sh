#!/usr/bin/env bash
# Reproducibility template for the documented workflow.
# This is NOT an exact historical command log. Review paths and parameters
# against the original NCBI record, reference, capture design, and analysis goal.

set -euo pipefail

RUN_ID="${RUN_ID:-SRR32633603}"
THREADS="${THREADS:-8}"
REFERENCE="${REFERENCE:-data/reference/tumor_genes.fa}"
SAMPLE="${SAMPLE:-SRR32633603}"

RAW="data/raw"
TRIMMED="data/trimmed"
ALIGN="data/alignment"
VCF_DIR="data/processed"
QC="results/qc_generated"

mkdir -p "$RAW" "$TRIMMED" "$ALIGN" "$VCF_DIR" "$QC/fastqc_raw" "$QC/fastqc_trimmed" "$QC/fastp"

# 1. Download public SRA run and create paired FASTQ files.
prefetch "$RUN_ID"
fasterq-dump "$RUN_ID" --split-files --threads "$THREADS" --outdir "$RAW"

# 2. Raw-read quality assessment.
fastqc -t "$THREADS" -o "$QC/fastqc_raw" \
  "$RAW/${RUN_ID}_1.fastq" "$RAW/${RUN_ID}_2.fastq"

# 3. Adapter and quality trimming.
fastp \
  --in1 "$RAW/${RUN_ID}_1.fastq" \
  --in2 "$RAW/${RUN_ID}_2.fastq" \
  --out1 "$TRIMMED/${RUN_ID}_1.trimmed.fastq.gz" \
  --out2 "$TRIMMED/${RUN_ID}_2.trimmed.fastq.gz" \
  --thread "$THREADS" \
  --html "$QC/fastp/${RUN_ID}.fastp.html" \
  --json "$QC/fastp/${RUN_ID}.fastp.json"

fastqc -t "$THREADS" -o "$QC/fastqc_trimmed" \
  "$TRIMMED/${RUN_ID}_1.trimmed.fastq.gz" \
  "$TRIMMED/${RUN_ID}_2.trimmed.fastq.gz"

# 4. Reference indexing. Run once for a new reference.
bwa index "$REFERENCE"
samtools faidx "$REFERENCE"
gatk CreateSequenceDictionary -R "$REFERENCE"

# 5. Alignment, conversion, sorting, and indexing.
bwa mem -t "$THREADS" "$REFERENCE" \
  "$TRIMMED/${RUN_ID}_1.trimmed.fastq.gz" \
  "$TRIMMED/${RUN_ID}_2.trimmed.fastq.gz" \
  | samtools view -@ "$THREADS" -b - \
  | samtools sort -@ "$THREADS" -o "$ALIGN/${SAMPLE}.sorted.bam" -

samtools index "$ALIGN/${SAMPLE}.sorted.bam"

# 6. Add read groups. Change LB/PL/PU values to match the NCBI metadata.
gatk AddOrReplaceReadGroups \
  -I "$ALIGN/${SAMPLE}.sorted.bam" \
  -O "$ALIGN/${SAMPLE}.rg.bam" \
  -RGID "$SAMPLE" \
  -RGLB "WES" \
  -RGPL "ILLUMINA" \
  -RGPU "unit1" \
  -RGSM "$SAMPLE"

samtools index "$ALIGN/${SAMPLE}.rg.bam"
samtools flagstat "$ALIGN/${SAMPLE}.rg.bam" > "$QC/${SAMPLE}.flagstat.txt"

# 7. Variant calling.
gatk HaplotypeCaller \
  -R "$REFERENCE" \
  -I "$ALIGN/${SAMPLE}.rg.bam" \
  -O "$VCF_DIR/variants.gatk.vcf" \
  --native-pair-hmm-threads 4 \
  --standard-min-confidence-threshold-for-calling 30

# 8. Select SNPs and apply the recorded hard filter.
gatk SelectVariants \
  -R "$REFERENCE" \
  -V "$VCF_DIR/variants.gatk.vcf" \
  --select-type-to-include SNP \
  -O "$VCF_DIR/raw_snps.vcf"

gatk VariantFiltration \
  -R "$REFERENCE" \
  -V "$VCF_DIR/raw_snps.vcf" \
  --filter-name "snp_filter" \
  --filter-expression "QD < 2.0 || FS > 60.0 || MQ < 40.0" \
  -O "$VCF_DIR/filtered_snps.vcf"

# 9. Reproduce downstream summaries and figures.
bash scripts/analysis/run_analysis.sh "$VCF_DIR/filtered_snps.vcf" results/generated
