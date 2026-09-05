# Load diamond module
module load diamond

# Perform protein blast against nr database
# db nr diamond database path
# q query protein fasta file
# o output file in format 6
diamond blastp --db /public2/shareddatabase/nr/DATE-Mar-12-2023/nr.dmnd -q Harpadon_nehereus_sweep_comp_longest.prot.fa -o Harpadon_nehereus_sweep_comp_fmt6.txt