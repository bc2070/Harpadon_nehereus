#!/usr/bin/bash
#SBATCH -p gpu
#SBATCH -c 30
#SBATCH --mem=210G

# Activate gpu conda environment
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate gpu

# Train diploSHIC model
# confusionFile output pdf for validation
# epochs number of training iterations
# trainingSets input data directory
# bfsModel output model prefix
diploSHIC train --confusionFile train.confusion.matrix.pdf --epochs 1000 trainingSets/ trainingSets/ bfsModel