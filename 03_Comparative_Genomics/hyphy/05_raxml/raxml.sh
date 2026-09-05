# run raxml with pthreads and avx2 optimizations
# -s: input alignment file
# -T: number of cores
# -f a: rapid bootstrap and best tree search
# -x: seed for rapid bootstrap
# -N: number of bootstrap replicates
# -m: model of nucleotide evolution
# -n: output file suffix
# -p: random seed for parsimony inference
/data/software/standard-RAxML-8.2.12/raxmlHPC-PTHREADS-AVX2 -s in.phy -T 48 -f a -x 23333 -N 100 -m GTRGAMMA -n allcodons -p 23333