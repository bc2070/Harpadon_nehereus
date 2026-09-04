#!/usr/bin/bash
#SBATCH -p long
#SBATCH -c 30
#SBATCH --mem=50G
source /data/software/funannotate/env.sh

GENOME=/data/projects/dyao/Data/pachycara/08_funannotate/01_cleangenome/pachycara.fasta
SPECIES="pachycara"

funannotate clean -i $GENOME -o pachycara_clean.fa -p 98 -c 98

