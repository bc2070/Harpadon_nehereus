# Define genome reference path
genome=/data/projects/lwang/genome/lty_genome/resequencing/01.SNP_calling/01.ref/lty_genome.upper.fasta

# Filter for biallelic snps and indels and normalize vcf
# view output compressed vcf containing only snps and indels
# norm normalize variants and split multiallelics
# f reference genome file
# output normalized vcf file
bcftools view -O z -M 2 -m 2 -i 'TYPE=="snp" || TYPE=="indel"' joincalled.genotyped.g.vcf.gz | \
bcftools norm -w 99999999 -O z -f $genome -  > joincalled.genotyped.snps.indels_norm.vcf.gz

# Index normalized vcf file
tabix joincalled.genotyped.snps.indels_norm.vcf.gz