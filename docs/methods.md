# Methods

## Data source

Public paired-end sequencing reads were obtained from NCBI SRA run `SRR32633603`. Raw FASTQ and BAM files are not stored in this repository.

## Quality control and preprocessing

FastQC 0.12.1 reports were reviewed for `SRR32633603_1` and `SRR32633603_2`. Basic statistics reported 26,740,039 sequences per file, 150 bp read length, 51% GC, and no sequences flagged as poor quality. Adapter and quality trimming were performed using fastp.

## Alignment and BAM processing

Reads were aligned with BWA to the project reference. SAM/BAM conversion, sorting, indexing, and assessment were performed with SAMtools, with read-group processing before GATK calling. Exact early-stage terminal history was not preserved in the source archive; the repository therefore supplies a labelled reproducibility template rather than presenting reconstructed commands as exact provenance.

## Variant calling and filtering

VCF headers record GATK 4.6.2.0 HaplotypeCaller, SelectVariants, and VariantFiltration. SNP hard filtering used:

```text
QD < 2.0 || FS > 60.0 || MQ < 40.0
```

Variants meeting the expression were labelled `snp_filter`; variants not meeting it remained `PASS`.

## Downstream analysis

The cleaned R script uses VariantAnnotation to load the VCF, extracts ranges and fixed metadata, calculates summaries, exports PASS variants and regional counts, and generates quality and target-region plots. The Python script independently parses the VCF and reports counts, sample genotypes, substitutions, top regions, and QUAL statistics.

## Traceability

Exact GATK commands are retained from the VCF header. Original exploratory scripts are included separately and labelled to distinguish real-VCF analysis from simulated plotting exercises.
