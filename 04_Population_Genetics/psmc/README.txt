PROJECT: MSMC2 Demographic History Inference
OVERVIEW
This pipeline estimates effective population size (Ne) over time using MSMC2, including VCF data processing, demographic inference, and bootstrapping for confidence interval estimation.
PIPELINE STEPS
--- PART I: DATA PRE-PROCESSING ---
01_vcf2msmc.sh : Filters VCFs by read depth, generates mappability masks, and converts site data into MSMC2-compatible multi-hetsep format.
--- PART II: DEMOGRAPHIC INFERENCE ---
02_runmsmc2.sh : Executes MSMC2 on the processed multi-hetsep files to estimate Ne trajectories for specified populations.
--- PART III: BOOTSTRAP ANALYSIS ---
03_bootstrap.sh : Performs block-bootstrapping on the multi-hetsep files to create pseudo-replicate datasets.
04_bootstraprun.sh : Runs MSMC2 on all bootstrap replicates to generate uncertainty intervals for the demographic history.