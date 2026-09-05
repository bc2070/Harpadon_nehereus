#!/usr/bin/bash
#SBATCH -p gpu
#SBATCH -c 30
#SBATCH --mem=210G

# Load conda environment
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate gpu

# Iterate over simulation output files
for f in exampleApplication/*.msOut.gz; do 
  # Check if feature vector file exists to avoid redundant computation
  if [ -f $f.diploid.fvec ]; then
	echo skip
  else
  # Generate feature vectors using diploSHIC
  # fvecSim simulation mode 
  # totalPhysLen specified locus length 220000
  # maskFileName genomic mask file
  diploSHIC fvecSim diploid $f $f.diploid.fvec --totalPhysLen 220000 --maskFileName snpable_split.150.final.mask.fa.gz & 
  fi
done
wait