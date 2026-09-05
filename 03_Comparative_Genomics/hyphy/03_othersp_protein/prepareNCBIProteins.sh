# iterate through species directories
for i in /data2/projects/dyao/compare/hyphy/00_species_forrelax/*; do
	if [ -d $i ]; then
		sp=`basename $i`
		# check for presence of protein fasta file
		if [ -f $i/*longest_isoform.prot.fa ]; then
			echo $i
			# preprocess amino acid sequences and output logs
			cat $i/*longest_isoform.prot.fa | php preprocessAA.php > $i.filtered.fa 2> $i.filtered.tab
			# run minreid script for sequence identification
			/data/software/UPhO/minreID.py $i.filtered.fa $sp \|
		fi
	fi
done

# concatenate all resulting fasta files
cat *.fst > allNCBIproteins.fa