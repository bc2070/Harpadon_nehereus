#!/bin/bash

# paths and parameters for hi-c assembly
contigs=/data/projects/dyao/data/pachycara/04_hic/references/ref.fa
mnd=/data/projects/dyao/data/pachycara/04_hic/aligned/merged_nodups.txt
mapq=30
gapsize=1000

# run 3d-dna chromosome assembly pipeline
/data/software/3d-dna-201008/run-asm-pipeline.sh -m haploid -i 100 -r 1 -q $mapq --sort-output -g $gapsize $contigs $mnd > 3ddna.log 2>&1