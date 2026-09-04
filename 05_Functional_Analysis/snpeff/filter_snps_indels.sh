genome=/data/projects/lwang/genome/lty_genome/resequencing/01.SNP_calling/01.ref/lty_genome.upper.fasta
bcftools view -O z -M 2 -m 2 -i 'TYPE=="snp" || TYPE=="indel"' joincalled.genotyped.g.vcf.gz | \
bcftools norm -w 99999999 -O z -f $genome -  > joincalled.genotyped.snps.indels_norm.vcf.gz
tabix joincalled.genotyped.snps.indels_norm.vcf.gz
