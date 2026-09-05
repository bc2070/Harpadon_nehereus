#!/usr/bin/bash
#SBATCH -p long
#SBATCH -c 30
#SBATCH --mem=50G

# load funannotate environment
source /data/software/funannotate/env.sh

# define input variables
GENOME=/data/projects/dyao/Data/pachycara/08_funannotate/01_cleangenome/pachycara.fasta
SPECIES="pachycara"

# clean genome assembly
funannotate clean -i $GENOME -o pachycara_clean.fa -p 98 -c 98

