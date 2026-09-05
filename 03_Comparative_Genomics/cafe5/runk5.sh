# configure paths and parameters
CAFE=/data/software/CAFE5/bin/cafe5
CPU=16
k=5


a=(8)
for i in ${a[*]}; do
	rm -r runresults_k$k/$i
	mkdir -p runresults_k$k/$i

# execute cafe5 pipeline
$CAFE -c $CPU -t tree.tre -i orthogroups.genecount.txt -p -eresults/Base_error_model.txt -k $k -o  runresults_k$k/$i >  runresults_k$k/$i/est.log 2>&1 
done
