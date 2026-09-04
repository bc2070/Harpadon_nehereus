#!/usr/bin/bash
#SBATCH -p hugemem
#SBATCH -c 50
#SBATCH --mem=300G


source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate gpu

chrprefix=scaffold_
vcf=vcf_file/Lty_LG.filtered.snps_reheader.g.vcf.gz
mask=snpable_split.150.final.mask.fa.gz
outdir=out
winsize=220000
mkdir -p $outdir

for nChr in `seq 13 24`; do
	sChr=${chrprefix}${nChr}
	sFvec=$outdir/$sChr/in.fvec

	diploSHIC predict bfsModel.json bfsModel.weights.hdf5 $sFvec  $outdir/$sChr/out.preds > $outdir/$sChr/predict.log 2>&1 &
done
wait
