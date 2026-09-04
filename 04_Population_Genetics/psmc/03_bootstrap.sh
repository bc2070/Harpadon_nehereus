bootstrap=/data/software/msmc-tools/multihetsep_bootstrap.py
nReps=30
nChunkSize=5000000

arrPops=( LG-1 LG-2 LG-3 LG-4 LG-5 LG-6 LG-7 LG-8 LG-9 LG-10 )

sOutDir=bootstrapped
sSrcDir=formsmc2_in

mkdir -p $sOutDir

for sPop in "${arrPops[@]}"; do
	sFiles="$sSrcDir/$sPop*/*/formsmc2.multihetsep.txt";
	sBSFolder="$sOutDir/$sPop/";
	mkdir -p $sBSFolder
	$bootstrap -n $nReps -s $nChunkSize --nr_chromosomes 1 --chunks_per_chromosome 196 --seed 33333 "$sBSFolder" $sFiles > $sBSFolder/bs.log 2>&1 &
done

wait

