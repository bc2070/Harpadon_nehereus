rohan="/data/software/ROHan-1.0.1/bin/rohan"
ref="/data/projects/lwang/genome/lty_genome/resequencing/01.SNP_calling/01.ref/lty_genome.upper.fasta"
sIn="/data2/projects/dyao/lty_snp/03.gatk/test/depthstats/all_ID.depth"
sBam_path="/data2/projects/dyao/lty_snp/03.gatk/02_rohan/all_mapbam_dedup1"
nL=0
cat $sIn | while read sL; do
	nL=$(expr $nL + 1)
	sRemainder=$(expr $nL % 3)
	if [ $sRemainder -eq 0 ]; then
		sAveDep=$(echo $sL | awk '{print $4}')	
		sStem=${sL%%:*}
		if [ $sAveDep -gt 4 ]; then
			echo $sStem
			mkdir -p $sStem && cd $sStem
			$rohan --rohmu 2e-5 -t 1 --size 50000 --step 100 -o $sStem $ref $sBam_path/$sStem*bam > run.log 2>&1 &
			cd ..
		fi	
	fi
done
wait


