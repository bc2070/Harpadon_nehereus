============================================================
PROJECT: Variant Annotation & Positive Selection Analysis
============================================================

1. OVERVIEW
This repository provides a framework for variant calling, functional 
annotation of mutations, and the detection of selective sweeps using 
deep learning (diploSHIC).

2. PIPELINE STEPS

--- PART I: VARIANT ANALYSIS (SnpEff) ---
filter_snps_indels.sh  : Quality filtering and normalization of raw VCFs.
snpeff.sh              : Annotation of functional variant effects.
reheader.sh            : Standardization of sample metadata for VCF consistency.

--- PART II: SELECTION SCAN (diploSHIC) ---
01-06_sim_train/       : Simulation of demographic models and CNN model training.
07_extract_fvec_real.sh: Feature extraction from real genomic data.
08_predict.sh          : Genome-wide inference of hard/soft selective sweeps.
09_filter_sweep_genes.sh: Mapping sweep regions to annotated candidate genes.
10-13_annotation/      : Protein sequence extraction and functional 
                         annotation using Diamond BLASTp.

3. DIRECTORY STRUCTURE
- snpeff/               : SNP/Indel processing, variant calling, and 
                          functional effect annotation.
- diploS_HIC/           : Deep learning pipeline for detecting selective 
                          sweeps and downstream functional analysis of 
                          candidate genes.