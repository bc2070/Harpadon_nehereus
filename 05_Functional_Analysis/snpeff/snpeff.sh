snpeffjar=/data/projects/dyao/App/snpEff/snpEff.jar
REF=Harpadon_nehereus_1.0

#tabix all.MHKhk.snps.indels.vcf.gz
bcftools merge --missing-to-ref -o all.joincalled.genotyped_merged.snps.indels.g.vcf.gz -O z joincalled.genotyped.snps.indels_norm.vcf.gz out.Harpadon_nehereus.Saurida_undosquamis_dp1_norm.vcf.gz Lam_in_anchorwave_35TR.vcf.normalized_rename.vcf.gz
java -Xmx26g -jar $snpeffjar $REF all.joincalled.genotyped_merged.snps.indels.g.vcf.gz | bgzip -c > all.joincalled.genotyped_merged.snps.indels.snpeff.vcf.gz


