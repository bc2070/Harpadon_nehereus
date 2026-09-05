# define msmc bootstrap tool and run parameters
bootstrap=/data/software/msmc-tools/multihetsep_bootstrap.py
nReps=30
nChunkSize=5000000

# define target populations
arrPops=( LG-1 LG-2 LG-3 LG-4 LG-5 LG-6 LG-7 LG-8 LG-9 LG-10 )

# define input and output directories
sOutDir=bootstrapped
sSrcDir=formsmc2_in

mkdir -p $sOutDir

# iterate through populations to generate bootstrap files
for sPop in "${arrPops[@]}"; do
	sFiles="$sSrcDir/$sPop*/*/formsmc2.multihetsep.txt";
	sBSFolder="$sOutDir/$sPop/";
	mkdir -p $sBSFolder
    
    # execute bootstrap with specified chunk size and seed
	$bootstrap -n $nReps -s $nChunkSize --nr_chromosomes 1 --chunks_per_chromosome 196 --seed 33333 "$sBSFolder" $sFiles > $sBSFolder/bs.log 2>&1 &
done

# wait for all parallel bootstrap tasks to complete
wait