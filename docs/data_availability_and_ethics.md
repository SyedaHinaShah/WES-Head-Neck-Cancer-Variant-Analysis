# Data availability, privacy, and ethics

## Public source

The source run is identified as NCBI SRA accession `SRR32633603`. Before publishing, open the NCBI record without a controlled-access login and confirm its current public availability and associated data-use statements.

## Repository policy

- Raw FASTQ, SAM, BAM, CRAM, and large reference files are not included.
- Small derived VCF and summary files are included to demonstrate the analysis.
- The MIT license applies to original code and documentation, not automatically to third-party sequencing data or deposited metadata.
- The original study and NCBI accession must be cited.

## Human genomic data

Human genomic data may remain sensitive even when direct identifiers are absent and the raw reads are publicly accessible. Do not add names, patient identifiers, sample keys, clinical identifiers, credentials, institutional paths, or unpublished collaborator information.

## Before making the repository public

1. Verify the NCBI run and related study are publicly accessible.
2. Add the related BioProject, BioSample, experiment, and original publication citation to `DATASET.md`.
3. Confirm that included derived files do not contain identifiers or private metadata.
4. Keep raw reads and alignment files outside GitHub.
5. State clearly that this is a secondary computational reanalysis and not clinical diagnosis.
