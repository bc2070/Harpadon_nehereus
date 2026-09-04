#!/usr/bin/bash
#SBATCH -p gpu
#SBATCH -c 50
#SBATCH --mem=210G


source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate gpu
module load bcftools

chrprefix=scaffold_
vcf=vcf_file/Lty_LG.filtered.snps_reheader.g.vcf.gz
mask=snpable_split.150.final.mask.fa.gz
outdir=out
winsize=220000
mkdir -p $outdir

for nChr in `seq 1 24`; do
	sChr=${chrprefix}${nChr}
	mkdir -p $outdir/$sChr
	nLen=`bcftools view -h $vcf | grep "##contig=<ID=$sChr,length=" | grep -oP 'length=(\d+)>' | grep -oP '(\d+)'`
	sOutFvec=$outdir/$sChr/in.fvec
#  echo $nLen
	diploSHIC fvecVcf diploid \
	$vcf $sChr $nLen \
	$sOutFvec \
	--targetPop LG --sampleToPopFileName samples_pops.txt --winSize $winsize \
	--maskFileName $mask \
	> $outdir/$sChr/fvecsample.log  2>&1 &

done
wait
