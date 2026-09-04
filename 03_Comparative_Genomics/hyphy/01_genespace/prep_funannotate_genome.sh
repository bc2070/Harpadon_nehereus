for i in /data2/projects/dyao/compare/hyphy/00_species_forrelax/*; do
{	sStem=$(basename $i)
	if [ -d "$i" ]
	then
		echo $sStem
		php prep_funannotate_genome.php $sStem $i/$sStem.longest_isoform.prot.fa
	else
		echo "this file is not directory"
	fi
} &	
done
wait

