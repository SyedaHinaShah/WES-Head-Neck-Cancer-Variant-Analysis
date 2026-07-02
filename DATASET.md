# Dataset source and attribution

## Source

The original paired-end sequencing reads used in this project were obtained from the **NCBI Sequence Read Archive (SRA)**.

- **SRA run accession:** `SRR32633603`
- **Database:** NCBI Sequence Read Archive
- **Analysis:** independent secondary bioinformatics reanalysis

The sequencing run used in this project is NCBI SRA accession `SRR32633603`. Associated BioProject, BioSample, experiment, platform, library strategy, and publication information should be taken directly from the official NCBI record.

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

This public repository does not include raw FASTQ, SAM, BAM, sample-level VCF, GDS, or large reference files. It provides analysis scripts, aggregate summary metrics, curated figures, and workflow documentation.
