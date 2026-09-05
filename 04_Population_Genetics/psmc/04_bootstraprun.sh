# define msmc2 executable path
MSMC2=/data/software/msmc2-2.1.3/build/release/msmc2

# define iteration parameters
nReps=30
nChunkSize=5000000

# define target populations
arrPops=( LG-6 LG-7 LG-8 LG-9 LG-10 )

# define input directory
sOutDir=bootstrapped

# iterate through populations and bootstrap replicates
for sPop in "${arrPops[@]}"; do
	for i in $(seq 1 $nReps); do 

		sBSFolder="$sOutDir/$sPop/_${i}";
        
        # run msmc2 for each replicate if output does not exist
		[ ! -s $sBSFolder/out.final.txt ] && $MSMC2 -o $sBSFolder/out -i 50 -t 1 -r 1 $sBSFolder/bootstrap_multihetsep.*.txt 2> /dev/null &
	done

done

# wait for all bootstrap jobs to complete
wait