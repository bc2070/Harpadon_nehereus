PROJECT: MCMCTree Divergence Time Estimation Pipeline
OVERVIEW
This pipeline prepares genomic data and phylogenies to estimate divergence times using PAML’s MCMCTree, employing an approximate likelihood calculation method.
PIPELINE STEPS
--- PART I: PRE-PROCESSING ---
partition_codonpos.php : Splits multi-gene Phylip files into separate blocks by codon position (1st, 2nd, and 3rd).
pre_tree.py : Cleans tree files (removes branch lengths/labels) to format them for MCMCTree compatibility.
--- PART II: LIKELIHOOD APPROXIMATION ---
approx.sh : Runs the initial MCMCTree analysis to estimate parameters (gradient and Hessian) for the approximate likelihood.
make.in.bv.sh : Finalizes the approximation to generate the in.BV file required for the main MCMC run.
--- PART III: MCMC ANALYSIS ---
sum.sh : Merges MCMC log samples from multiple parallel chains and executes the final MCMCTree estimation.