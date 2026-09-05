# Define snpeff path and reference genome
snpeffjar=/data/projects/dyao/App/snpEff/snpEff.jar
REF=Harpadon_nehereus_1.0

# Merge vcf files and fill missing sites with reference alleles
# O z output compressed format
# input multiple vcf files
bcftools merge --missing-to-ref -o all.joincalled.genotyped_merged.snps.indels.g.vcf.gz -O z joincalled.genotyped.snps.indels_norm.vcf.gz out.Harpadon_nehereus.Saurida_undosquamis_dp1_norm.vcf.gz Lam_in_anchorwave_35TR.vcf.normalized_rename.vcf.gz

# Run snpEff to annotate variants
# Xmx set memory limit
# jar execute snpeff jar file
# output pipe to bgzip for compression
java -Xmx26g -jar $snpeffjar $REF all.joincalled.genotyped_merged.snps.indels.g.vcf.gz | bgzip -c > all.joincalled.genotyped_merged.snps.indels.snpeff.vcf.gz