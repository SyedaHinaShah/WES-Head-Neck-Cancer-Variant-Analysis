# Pipeline overview

## 1. Public data acquisition

The paired-end sequencing run was obtained from NCBI SRA accession `SRR32633603`. Raw FASTQ files are not committed to GitHub because they are large and can be downloaded again from NCBI.

## 2. Raw-read quality assessment

Paired files `SRR32633603_1.fastq` and `SRR32633603_2.fastq` were assessed using FastQC 0.12.1.

- 26,740,039 sequences per read file
- 150 bp read length
- 51% GC
- zero reads flagged as poor quality in FastQC basic statistics
- read 1 warnings: tile quality, base composition, and sequence GC distribution
- read 2 warning: sequence GC distribution

## 3. Read preprocessing

Adapter and quality trimming were performed using fastp. The raw command history and fastp HTML/JSON reports were not present in the supplied archive, so this stage is documented from the author's workflow statement rather than claimed as a fully preserved execution record.

## 4. Alignment and SAM/BAM processing

Reads were aligned using BWA, followed by SAM/BAM processing using SAMtools and read-group processing. The original software notes include BWA, SAMtools, Picard, and GATK. The exact alignment and BAM-preprocessing command history was not preserved in the uploaded archive.

## 5. Variant calling

The raw VCF header records GATK HaplotypeCaller version 4.6.2.0 using:

- input: `tumor_genes.rg.bam`
- reference: `tumor_genes.fa`
- output: `variants.gatk.vcf`
- minimum calling confidence: 30
- native PairHMM threads: 4

The full recorded command is retained in `gatk_provenance_from_vcf_header.txt`.

## 6. SNP selection and hard filtering

The filtered VCF records:

- GATK SelectVariants for SNP selection
- GATK VariantFiltration
- filter expression: `QD < 2.0 || FS > 60.0 || MQ < 40.0`
- filter label: `snp_filter`

## 7. Downstream analysis

R/Bioconductor and Python were used to calculate:

- raw and filtered variant counts
- PASS rate
- QUAL summaries
- genotype frequencies
- transition/transversion classification
- target-region variant counts
- quality distributions and density plots

## 8. Communication outputs

The project includes a GitHub README, GitHub Pages site, research portfolio, CV material, and professor-facing presentation.

## Provenance boundary

The GATK variant-calling and filtering commands are directly supported by VCF header metadata. Earlier SRA download, fastp, alignment, and SAM/BAM commands are represented by a clearly labelled template because the exact terminal history was not included in the source archives.
