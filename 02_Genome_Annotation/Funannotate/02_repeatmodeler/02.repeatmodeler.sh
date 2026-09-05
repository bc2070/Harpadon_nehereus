#!/usr/bin/bash
#SBATCH -p long
#SBATCH -c 40
#SBATCH --mem=200G

ASSEMBLY=/data/projects/dyao/Data/pachycara/08_funannotate/02_repeatmodeler/pachycara_sort.fa # the assembly to look at
SP=pachycara
REPMODEL="singularity run docker://dfam/tetools:latest " #command of repeatmodeler
THREADS=40

# build repeatmodeler database
$REPMODEL BuildDatabase -name $SP -engine ncbi $ASSEMBLY

# run repeatmodeler to identify repeat families
$REPMODEL RepeatModeler -LTRStruct -engine ncbi -threads $THREADS -database $SP

