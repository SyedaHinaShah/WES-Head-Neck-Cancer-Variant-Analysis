#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 /path/to/filtered_snps.vcf [output_dir]" >&2
  exit 1
fi
VCF=$1
OUT=${2:-results/generated}
mkdir -p "$OUT"

python scripts/analysis/vcf_summary.py "$VCF" --output "$OUT/vcf_summary.json"

if command -v Rscript >/dev/null 2>&1; then
  Rscript scripts/analysis/wes_snp_analysis.R "$VCF" "$OUT"
else
  echo "Rscript is not installed; Python summary completed, R analysis skipped." >&2
fi
