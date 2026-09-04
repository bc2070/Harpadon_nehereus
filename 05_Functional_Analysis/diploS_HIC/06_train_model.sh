#!/usr/bin/bash
#SBATCH -p gpu
#SBATCH -c 30
#SBATCH --mem=210G


source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate gpu

diploSHIC train --confusionFile train.confusion.matrix.pdf --epochs 1000 trainingSets/ trainingSets/ bfsModel
