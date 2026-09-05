# initialize conda environment
source /opt/miniconda3/etc/profile.d/conda.sh

# add software paths to environment
export PATH=$PATH:/data/software/MCScanX:/opt/miniconda3/bin/

# run r script and log output
Rscript run.R > run.log 2>&1