# configure paths and parameters
cafe=/data/software/cafe5/bin/cafe5
cpu=16
k=2

# iterate over specified values for cafe runs
a=(14 17)
for i in ${a[*]}; do
    # create output directory
    mkdir -p runresults_k$k/$i
    
    # execute cafe5 pipeline
    $cafe -c $cpu -t tree.tre -i orthogroups.genecount.txt -p -eresults/base_error_model.txt -k $k -o runresults_k$k/$i > runresults_k$k/$i/est.log 2>&1 
done