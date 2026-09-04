# extract gamma results from run directories
for i in run*/*/gamma_results.txt; do
    k=`dirname $i`
    echo $k >> stats.txt
    head -1 $i >> stats.txt
done