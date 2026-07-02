#!/usr/bin/env python3
"""Create a lightweight JSON summary from a single- or multi-sample VCF."""
from __future__ import annotations

import argparse
import json
import statistics
from collections import Counter
from pathlib import Path
from typing import Any


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("vcf", type=Path, help="Input VCF file")
    parser.add_argument("--output", type=Path, help="Optional JSON output path")
    return parser.parse_args()


def summarize_vcf(path: Path) -> dict[str, Any]:
    if not path.is_file():
        raise FileNotFoundError(f"VCF not found: {path}")

    sample_names: list[str] = []
    records = 0
    quals: list[float] = []
    filters: Counter[str] = Counter()
    contigs: Counter[str] = Counter()
    genotypes: dict[str, Counter[str]] = {}
    substitutions: Counter[str] = Counter()

    with path.open(encoding="utf-8") as handle:
        for raw_line in handle:
            if raw_line.startswith("##"):
                continue
            if raw_line.startswith("#CHROM"):
                header = raw_line.rstrip("\n").lstrip("#").split("\t")
                sample_names = header[9:]
                genotypes = {sample: Counter() for sample in sample_names}
                continue
            if not raw_line.strip():
                continue

            fields = raw_line.rstrip("\n").split("\t")
            if len(fields) < 8:
                raise ValueError(f"Malformed VCF record with {len(fields)} fields")

            chrom, _pos, _id, ref, alt, qual, filt, _info = fields[:8]
            records += 1
            contigs[chrom] += 1
            filters[filt] += 1
            if qual != ".":
                quals.append(float(qual))

            alt_alleles = alt.split(",")
            if len(ref) == 1 and len(alt_alleles) == 1 and len(alt_alleles[0]) == 1:
                substitutions[f"{ref}>{alt_alleles[0]}"] += 1

            if sample_names and len(fields) >= 9:
                format_keys = fields[8].split(":")
                try:
                    gt_index = format_keys.index("GT")
                except ValueError:
                    gt_index = -1
                for sample, sample_value in zip(sample_names, fields[9:]):
                    parts = sample_value.split(":")
                    gt = parts[gt_index] if gt_index >= 0 and gt_index < len(parts) else "."
                    genotypes[sample][gt] += 1

    summary: dict[str, Any] = {
        "file": str(path),
        "records": records,
        "sample_names": sample_names,
        "filter_counts": dict(filters),
        "genotype_counts": {name: dict(counts) for name, counts in genotypes.items()},
        "substitution_counts": dict(substitutions),
        "top_contigs_or_regions": dict(contigs.most_common(10)),
    }
    if quals:
        summary["qual"] = {
            "minimum": min(quals),
            "maximum": max(quals),
            "mean": round(statistics.fmean(quals), 2),
            "median": round(statistics.median(quals), 2),
        }
    else:
        summary["qual"] = None
    return summary


def main() -> int:
    args = parse_args()
    summary = summarize_vcf(args.vcf)
    rendered = json.dumps(summary, indent=2)
    print(rendered)
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered + "\n", encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
