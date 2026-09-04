cat genespace.orthogroups.txt | awk -F'\t' '{split($17, a, "|"); print $1"\t"a[3]}'  > groupid2transid.Pachy.txt
