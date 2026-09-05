# iterate through each directory in the source path
for i in /data2/projects/dyao/compare/hyphy/00_species_forrelax/*; do
{	
    # extract directory name
    sStem=$(basename $i)
    
    # check if path is a directory
	if [ -d "$i" ]
	then
        # display current species name
		echo $sStem
        
        # run php script with species name and protein file path
		php prep_funannotate_genome.php $sStem $i/$sStem.longest_isoform.prot.fa
	else
        # skip non-directory files
		echo "this file is not directory"
	fi
} &	# run in background for parallel processing
done
# wait for all background tasks to complete
wait