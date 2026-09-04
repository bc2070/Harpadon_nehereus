MSMC2=/data/software/msmc2-2.1.3/build/release/msmc2

arrPops=( LG-1 LG-2 LG-3 LG-4 LG-5 LG-6 LG-7 LG-8 LG-9 LG-10 )
sIn=formsmc2_in
sOut=msmc2ret
recOverMu=1

mkdir -p $sOut


for sPop in "${arrPops[@]}"; do
	sFiles="${sIn}/${sPop}*/*/formsmc2.multihetsep.txt"
	sCmd="$MSMC2 -o $sOut/$sPop -r $recOverMu -i 50 -t 12 $sFiles > /dev/null "
	eval $sCmd > /dev/null 2>&1 &
done

wait

