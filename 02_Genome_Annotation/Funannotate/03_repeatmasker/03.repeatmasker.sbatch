#!/usr/bin/bash
#SBATCH -c 15
#SBATCH -p long
#SBATCH --mem=40G

ASSEMBLY=/data/projects/dyao/Data/pachycara/08_funannotate/01_cleangenome/pachycara_sort.fa # assembly to mask
REPBASELIB=`realpath ./all_te.fa` #repeat library, with killifish repeats
THREADS=36

ln -sf $ASSEMBLY scf.fa


singularity run docker://dfam/tetools:latest RepeatMasker -gff -html -pa $THREADS -lib $REPBASELIB  scf.fa

