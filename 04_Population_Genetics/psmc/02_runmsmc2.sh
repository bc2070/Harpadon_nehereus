# define msmc2 executable path
MSMC2=/data/software/msmc2-2.1.3/build/release/msmc2

# define populations and directories
arrPops=( LG-1 LG-2 LG-3 LG-4 LG-5 LG-6 LG-7 LG-8 LG-9 LG-10 )
sIn=formsmc2_in
sOut=msmc2ret
recOverMu=1

# create output directory
mkdir -p $sOut

# iterate through populations to execute msmc2
for sPop in "${arrPops[@]}"; do
    # locate all multihetsep files for the current population
	sFiles="${sIn}/${sPop}*/*/formsmc2.multihetsep.txt"
    
    # build command for msmc2 analysis
	sCmd="$MSMC2 -o $sOut/$sPop -r $recOverMu -i 50 -t 12 $sFiles > /dev/null "
    
    # run analysis in background
	eval $sCmd > /dev/null 2>&1 &
done

# wait for all population analyses to complete
wait