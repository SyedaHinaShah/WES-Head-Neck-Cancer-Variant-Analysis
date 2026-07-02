# Reproducibility

## Recommended environment

- Linux or WSL Ubuntu
- NCBI SRA Toolkit
- FastQC and fastp
- BWA and SAMtools
- Picard-compatible read-group processing
- GATK 4.6.2.0 for consistency with the supplied VCF provenance
- Python 3
- R with Bioconductor

## Setup

```bash
bash scripts/setup/install_ubuntu_tools.sh
Rscript scripts/setup/install_r_packages.R
```

## Download the original run

```bash
prefetch SRR32633603
fasterq-dump SRR32633603 --split-files --threads 8 --outdir data/raw
```

## Run the included downstream analysis

```bash
bash scripts/analysis/run_analysis.sh
```

## Full workflow template

Review and edit variables before running:

```bash
bash workflow/full_pipeline_template.sh
```

The template demonstrates the documented tool sequence but is not an exact record of the original early-stage terminal commands.

## Reproducibility boundaries

The repository directly reproduces summaries and plots from the included filtered VCF. Exact GATK calling and filtering provenance is preserved in the VCF header. Raw FASTQ, BAM, project reference FASTA, fastp reports, and the exact early preprocessing command history were not included in the source archive, so a bit-for-bit recreation of the complete original run is not guaranteed without restoring those inputs and parameters.
