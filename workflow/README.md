# Workflow documentation

- [`pipeline_overview.md`](pipeline_overview.md): evidence-based description of the complete workflow.
- [`full_pipeline_template.sh`](full_pipeline_template.sh): editable SRA-to-VCF reproducibility template; not an exact historical command log.
- [`gatk_provenance_from_vcf_header.txt`](gatk_provenance_from_vcf_header.txt): exact GATK command metadata extracted from the supplied VCF.
- [`software_versions.md`](software_versions.md): confirmed and unrecorded tool versions.

The VCF header is the strongest source of provenance for variant calling and filtering because it records tool names, versions, dates, inputs, outputs, and parameters.
