#!/usr/bin/bash
#SBATCH -p long
#SBATCH -c 30
#SBATCH --mem=50G

# load funannotate environment
source /data/software/funannotate/env.sh

# define input variables
GENOME=pachycara_clean.fa
SPECIES="pachycara"

# sort assembly by size and rename contigs
funannotate sort -i $GENOME -o pachycara_sort.fa -b pachyScf

