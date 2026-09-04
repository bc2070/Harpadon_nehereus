PROJECT: SNP/Indel Calling & Functional Annotation with SnpEff
OVERVIEW
This pipeline processes VCF data by filtering variants, merging multi-sample datasets, and performing functional annotation of SNPs and Indels using SnpEff.
PIPELINE STEPS
--- PART I: VARIANT PRE-PROCESSING ---
filter_snps_indels.sh : Filters VCFs for SNPs and Indels, followed by normalization against the reference genome.
--- PART II: DATA INTEGRATION ---
snpeff.sh : Merges multiple VCF datasets into a unified file and runs SnpEff to annotate variant effects based on a defined reference database.
reheader.sh : Updates sample metadata within the annotated VCF file to ensure consistent nomenclature for downstream analysis.