#!/usr/bin/bash
#SBATCH -p long,himem,blade
#SBATCH -c 64
#SBATCH --mem=100G
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate funannotate1.8.15

GENOME=pachycara_scf.softmasked.fa
TRINITY_TRANSCRIPT=pachycara_combtrinity.fa
SPECIES="pachycara"
STRAIN="deep_sea"
CPU=64

funannotate train -i $GENOME -o trained_1  \
--left left.fq.gz \
--right right.fq.gz  \
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

