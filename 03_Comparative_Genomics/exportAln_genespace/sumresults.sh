#!/bin/bash

# initialize counter to track the first file
nCount=1

# iterate through all relax result files
for d in output/*_RELAX.txt ; do
    echo "$d"
    # if this is the first file, copy it with headers
    if [ "$nCount" = "1" ]; then
        echo first
        cat $d > ./ret_RELAX.txt
        nCount=0
    else
        # for subsequent files, skip header (first line) and append
        tail -n+2 $d >> ./ret_RELAX.txt
    fi
done

# concatenate all clean dna fasta sequences
cat output/*_cleanDNA.fasta > ret_improved_cleanDNA.fasta

# concatenate all amino acid fasta sequences
cat output/*_AA.fasta > ret_AA.fasta