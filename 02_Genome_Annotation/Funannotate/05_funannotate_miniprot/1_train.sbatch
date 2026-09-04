#!/usr/bin/bash
#SBATCH -p long,himem,blade,gpu
#SBATCH -c 24
#SBATCH --mem=80G
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate funannotate1.8.15

GENOME=/public3/group_crf/home/g22yaodj3/Data/pachycara/08_funannotate/05_funannotate_miniprot/pachycara_scf.softmasked.fa
TRINITY_TRANSCRIPT=/public3/group_crf/home/g22yaodj3/Data/pachycara/miniprot/joined_miniprot_trinity.trans.fasta
SPECIES="pachycara"
STRAIN="deep_sea_1" 
CPU=24

funannotate train -i $GENOME -o trained_1  \
--left /public3/group_crf/home/g22yaodj3/Data/pachycara/08_funannotate/05_funannotate_miniprot/left.fq.gz \
--right /public3/group_crf/home/g22yaodj3/Data/pachycara/08_funannotate/05_funannotate_miniprot/right.fq.gz  \
--no_trimmomatic \
--no_normalize_reads \
--pasa_min_avg_per_id 72 \
--jaccard_clip \
--memory 100G \
--trinity "$TRINITY_TRANSCRIPT" \
--species "$SPECIES" \
--pasa_db mysql \
--max_intronlen 200000 \
--aligners minimap2 minimap2 \
--strain "$STRAIN" --cpus $CPU 
