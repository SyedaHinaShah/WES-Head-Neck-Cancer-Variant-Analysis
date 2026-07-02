# Software versions

## Confirmed from generated files

| Tool | Version | Evidence |
|---|---:|---|
| FastQC | 0.12.1 | `fastqc_data.txt` headers for both reads |
| GATK HaplotypeCaller | 4.6.2.0 | VCF header |
| GATK SelectVariants | 4.6.2.0 | VCF header |
| GATK VariantFiltration | 4.6.2.0 | VCF header |

## Used but exact version not preserved in the supplied archive

- NCBI SRA Toolkit
- fastp
- BWA
- SAMtools
- Picard/read-group processing
- R and Bioconductor packages
- Python

For future work, capture versions with commands such as:

```bash
prefetch --version
fasterq-dump --version
fastqc --version
fastp --version
bwa 2>&1 | head -n 3
samtools --version
picard AddOrReplaceReadGroups --version
gatk --version
R --version
python3 --version
```
