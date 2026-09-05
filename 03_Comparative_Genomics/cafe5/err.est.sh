# set path to cafe5 binary
CAFE=/data/software/CAFE5/bin/cafe5
CPU=32

# estimate error rates for gene family evolution model
$CAFE -c $CPU -t tree.tre -i orthogroups.genecount.txt -p -e > err.est.log 2>&1 
