# extract group id and corresponding transcript id from the orthogroups file
cat genespace.orthogroups.txt | awk -F'\t' '{split($4, a, "|"); print $1"\t"a[3]}'  > groupid2transid.BTP.txt
