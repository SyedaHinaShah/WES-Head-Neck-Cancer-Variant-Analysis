# Dataset source and attribution

## Source

The original paired-end sequencing reads used in this project were obtained from the **NCBI Sequence Read Archive (SRA)**.

- **SRA run accession:** `SRR32633603`
- **Database:** NCBI Sequence Read Archive
- **Analysis:** independent secondary bioinformatics reanalysis

An `SRR` accession identifies an SRA **run**. Before final publication, copy the associated BioProject, BioSample, experiment accession, library strategy, platform, and original publication citation from the NCBI record into this file.

## Download example

The raw reads are intentionally not stored in GitHub. They can be retrieved with the SRA Toolkit:

```bash
mkdir -p data/raw
prefetch SRR32633603
fasterq-dump SRR32633603 \
  --split-files \
  --threads 8 \
  --outdir data/raw
```

Optional compression:

```bash
gzip data/raw/SRR32633603_1.fastq
gzip data/raw/SRR32633603_2.fastq
```

## Attribution statement

The original sequencing data were generated and deposited by the investigators associated with the NCBI SRA record. Syeda Hina Shah independently downloaded and reanalysed the public data, including quality assessment, read preprocessing, alignment, SAM/BAM processing, variant calling, VCF filtering, downstream statistical analysis, visualization, interpretation, and documentation.

## Data-sharing boundary

This repository does not include raw FASTQ files, BAM files, or large reference files. Small derived VCF and summary files are included for reproducibility. Human genomic data can remain sensitive even when the source reads are publicly accessible; users should follow the original record's consent, attribution, and data-use conditions.
