for sSample in ./*.prot.fa
do
        sBase=`basename $sSample`
        sName=${sBase/.prot.fa/}
awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $sSample > ${sName}.prot1.fa
done
