#!/usr/bin/bash
#SBATCH -p long
#SBATCH -c 30
#SBATCH --mem=50G
source /data/software/funannotate/env.sh

GENOME=pachycara_clean.fa
SPECIES="pachycara"

funannotate sort -i $GENOME -o pachycara_sort.fa -b pachyScf

