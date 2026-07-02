#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y \
  sra-toolkit \
  fastqc \
  fastp \
  bwa \
  samtools \
  picard-tools \
  bedtools \
  bcftools \
  tabix \
  default-jre \
  python3 \
  python3-venv \
  r-base

cat <<'MSG'
Core Ubuntu tools installed.
GATK and some annotation tools require separate installation.
Check the official documentation for your operating system and record every
version before running the workflow.
MSG
