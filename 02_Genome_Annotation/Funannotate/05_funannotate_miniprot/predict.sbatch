#!/usr/bin/bash
#SBATCH -p himem,long,blade,gpu,hugemem
#SBATCH -c 24
#SBATCH --mem=80G

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate funannotate1.8.15

GENOME=/public3/group_crf/home/g22yaodj3/Data/pachycara/08_funannotate/05_funannotate_miniprot/pachycara_scf.softmasked.fa
PROTEIN_EVIDENCE=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/all.prot.fa
SPECIES="pachycara"
STRAIN="deep_sea_1"
CPU=24

 funannotate predict --force  -i $GENOME \
            -o trained_1 -s "$SPECIES" --cpus $CPU \
--max_intronlen 200000 \
--weights augustus:10 hiq:10 pasa:10 snap:0 genemark:0 glimmerhmm:0 proteins:10 transcripts:1 \
--optimize_augustus \
--busco_db actinopterygii \
--busco_seed_species zebrafish \
--organism other \
--protein_evidence  $PROTEIN_EVIDENCE \
#--stringtie $STRINGTIE \
--keep_no_stops \
--min_protlen 10 \
--strain "$STRAIN" \
--repeat_filter none
#--repeats2evm \
#--no-evm-partitions \
# StartWeights = {'augustus': 1, 'hiq': 2, 'genemark': 1, 'pasa': 6,'codingquarry': 0, 'snap': 1, 'glimmerhmm': 1, 'proteins': 1, 'transcripts': 1}
