# Update sample names in vcf header
# s input sample list file
# input vcf file
# o output reheaded vcf file
bcftools reheader -s reheader.txt all.joincalled.genotyped_merged.snps.indels.snpeff.vcf.gz -o all.joincalled.genotyped_merged.snps.indels_reheader.snpeff.vcf.gz