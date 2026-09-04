#!/usr/bin/bash
#SBATCH -p long,blade,himem,hugemem,gpu
#SBATCH -c 32
#SBATCH --mem=50G

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate funannotate1.8.15

funannotate update -i trained_1 --cpus 32 --pasa_db mysql --alt_transcripts 0.3 \
--left /public3/group_crf/home/g22yaodj3/Data/pachycara/08_funannotate/05_funannotate_miniprot/left.fq.gz \
--right /public3/group_crf/home/g22yaodj3/Data/pachycara/08_funannotate/05_funannotate_miniprot/right.fq.gz  \
--no_trimmomatic \
--no_normalize_reads \
