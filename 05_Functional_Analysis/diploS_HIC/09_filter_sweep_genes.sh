source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate /public3/group_crf/home/g21shaoy23/.conda/envs/bedtools

bedtools intersect -a Harpadon_nehereus.longest_isoform.gff3 -b sweep.gff3 > Harpadon_nehereus_sweep.gff3
