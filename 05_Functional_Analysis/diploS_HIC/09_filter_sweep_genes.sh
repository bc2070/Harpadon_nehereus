# Activate conda environment for bedtools
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate /public3/group_crf/home/g21shaoy23/.conda/envs/bedtools

# Intersect gene annotations with identified sweep regions
# a gene annotation file
# b sweep region file
# output intersecting regions to new gff3 file
bedtools intersect -a Harpadon_nehereus.longest_isoform.gff3 -b sweep.gff3 > Harpadon_nehereus_sweep.gff3