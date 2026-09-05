# Iterate through all protein fasta files in the current directory
for sSample in ./*.prot.fa
do
        sBase=`basename $sSample`
        sName=${sBase/.prot.fa/}
        
        # Reformat fasta sequence to single line per sequence
        # remove newlines within sequence blocks
        awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $sSample > ${sName}.prot1.fa
done