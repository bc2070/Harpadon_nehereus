#!/usr/bin/bash
#SBATCH -p gpu
#SBATCH -c 30
#SBATCH --mem=210G

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate gpu

for f in exampleApplication/*.msOut.gz; do 
  if [ -f $f.diploid.fvec ]; then
	echo skip
  else
  diploSHIC fvecSim diploid $f $f.diploid.fvec --totalPhysLen 220000 --maskFileName snpable_split.150.final.mask.fa.gz & 
  fi
done
wait

