# define genome path and create absolute link
genome=/data/projects/dyao/data/youwei/03_nextpolish/purge/youwei_curated.fasta
genome=`realpath $genome`

# prepare reference files for juicer
mkdir -p references
ln -sf $genome references/ref.fa
bwa index references/ref.fa
fastahack -i references/ref.fa

# generate chromosome size file
mkdir -p restriction_sites
cut -f1,2 references/ref.fa.fai > restriction_sites/ref.chrom.sizes

# identify restriction enzyme site positions
cd restriction_sites
python /data/software/juicer/misc/generate_site_positions.py dpnii ref ../references/ref.fa