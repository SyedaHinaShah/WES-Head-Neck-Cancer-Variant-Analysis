# Results

## Sequencing quality

Both paired-read files contained 26,740,039 sequences of 150 bp with 51% GC. Read 1 received FastQC warnings for tile quality, base composition, and sequence GC content. Read 2 received a warning for sequence GC content. Most other modules passed.

## Variant filtering

The raw VCF contained 751 records. SNP selection and hard filtering produced 621 SNP records: 330 PASS and 291 labelled `snp_filter`, giving a PASS rate of 53.1%.

## Quality statistics

The filtered SNP set had a mean QUAL of 513.30, median QUAL of 166.14, and maximum QUAL of 10,192.06. PASS variants had a mean QUAL of 579.66 and median QUAL of 172.14.

## Genotypes and substitutions

The filtered VCF genotype counts were 497 heterozygous `0/1`, 109 homozygous alternate `1/1`, and 15 multiallelic `1/2`. Allele changes included 455 transitions, 151 transversions, and 15 other patterns.

## Interpretation

The results show successful extraction and visualization of quality-filtered variants from a single-sample, targeted-region-style VCF. They do not establish disease association, population frequency, clinical pathogenicity, or treatment relevance without external annotation, controls, validation, and a larger study design.
