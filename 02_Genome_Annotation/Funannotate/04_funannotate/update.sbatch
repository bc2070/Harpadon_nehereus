#!/usr/bin/bash
#SBATCH -p long
#SBATCH -c 64
#SBATCH --mem=50G

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate funannotate1.8.15

funannotate update -i trained_2 --cpus 64 --pasa_db mysql --alt_transcripts 0.3

