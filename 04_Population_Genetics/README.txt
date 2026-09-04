============================================================
PROJECT: Population Genomics & Demographic Inference Pipeline
============================================================

1. OVERVIEW
This pipeline covers the full workflow of population genomics, from 
raw read variant calling and filtration, to population structure 
analysis (PCA/Kinship), and demographic history reconstruction (PSMC/ROH).

2. PIPELINE STEPS

--- PART I: VARIANT CALLING (GATK) ---
do_gatk.sh        : Driver script to process multiple BAM files in parallel.
gatk.sh           : Full GATK workflow including sorting, read group tagging, 
                    duplicate marking, and HaplotypeCaller genotype calling.

--- PART II: POPULATION STRUCTURE (PCA & Kinship) ---
pca/run_plink2_pca.slrm : VCF cleaning, LD pruning, and PCA analysis via PLINK2.
pca/plot_pca.R          : Visualization of PCA results using ggplot2.
popkin/popkin.R         : Kinship matrix estimation and pairwise Fst calculation.

--- PART III: DEMOGRAPHIC & RUNS OF HOMOZYGOSITY (ROH) ---
psmc/01_vcf2msmc.sh     : VCF filtering and conversion to multi-hetsep format.
psmc/02-04_msmc2.sh     : Demographic history inference (Ne) and bootstrapping.
rohan/run_rohan.sh      : Detection of Runs of Homozygosity (ROH) using ROHan.

3. DIRECTORY STRUCTURE
- gatk/         : GATK HaplotypeCaller variant calling pipeline.
- pca/          : PLINK2-based PCA analysis and R visualization scripts.
- popkin/       : Kinship and population structure estimation.
- psmc/         : MSMC2 pipeline for historical effective population size (Ne).
- rohan/        : Identification of ROH to assess inbreeding and genomic diversity.