============================================================
PROJECT: DiploSHIC Selection Scan & Functional Annotation
============================================================

1. OVERVIEW
This pipeline detects selective sweeps (hard/soft) using deep learning 
(diploSHIC) and annotates candidate genes under selection.

2. PIPELINE STEPS

--- PART I: SIMULATION & MODEL TRAINING ---
01_sim_neutral.sh       : Simulate neutral demographic history.
02_sim_hard.sh          : Simulate hard sweep scenarios.
03_sim_soft.sh          : Simulate soft sweep scenarios.
04_extract_fvec_sim.sh  : Convert simulation outputs to feature vectors (.fvec).
05_make_trainset.sh     : Aggregate features into training sets.
06_train_model.sh       : Train the CNN model (output: bfsModel.json/weights.hdf5).

--- PART II: INFERENCE & ANNOTATION ---
07_extract_fvec_real.sh : Extract features from real genomic VCF data.
08_predict.sh           : Predict sweep states across the genome.
09_filter_sweep_genes.sh: Intersect sweep regions with GFF3 annotations.
10_simplify_gff.sh      : Keep longest isoforms to reduce redundancy.
11_extract_proteins.sh  : Extract protein sequences for candidate genes.
12_format_fasta.sh      : Reformat protein FASTA to single-line format.
13_run_diamond.sh       : Functional annotation via Diamond BLASTp.