MSMC2=/data/software/msmc2-2.1.3/build/release/msmc2

nReps=30
nChunkSize=5000000

arrPops=( LG-6 LG-7 LG-8 LG-9 LG-10 )
#arrPops=( LG-1 LG-2 LG-3 LG-4 LG-5 )

sOutDir=bootstrapped


for sPop in "${arrPops[@]}"; do
	for i in $(seq 1 $nReps); do 

		sBSFolder="$sOutDir/$sPop/_${i}";
		[ ! -s $sBSFolder/out.final.txt ] && $MSMC2 -o $sBSFolder/out -i 50 -t 1 -r 1 $sBSFolder/bootstrap_multihetsep.*.txt 2> /dev/null &
	done

done

wait

