# Reference files

The complete project reference was not included because genome FASTA/GTF files are large and should not be stored in normal Git history.

The VCF header records a project reference named `tumor_genes.fa`, indicating a project-specific target reference rather than a standard whole-chromosome FASTA. To reproduce the original variant coordinates exactly, the same reference sequence and indexes are required.

Document here, before final publication if known:

- source genome build;
- how `tumor_genes.fa` was generated;
- target genes or regions;
- source annotation release;
- checksums of the reference and index files.

The original archive included `Homo_sapiens.GRCh38.111.gtf`, but this 1.46 GB annotation file is intentionally excluded from GitHub.
