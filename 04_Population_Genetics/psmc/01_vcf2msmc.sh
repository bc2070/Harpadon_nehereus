# define paths for msmc tools and bcftools
vcfcaller=/data/software/msmc-tools/vcfAllSiteParser.py
CONVERT=/data/software/msmc-tools/generate_multihetsep.py
BCFTOOLS="bcftools"

# input and output configuration
sVCFFolder=/data2/projects/dyao/lty_snp/03.gatk/
sVCFSuffix=.bam.genotyped.g.vcf.gz
sChrSuffix="scaffold_"
sRef=
sOutDir=formsmc2_in/

# sample lists and coverage thresholds
arrSamples=( LG-1 LG-2 LG-3 LG-4 LG-5 LG-6 LG-7 LG-8 LG-9 LG-10 )
arrCovUpper=( 14 14 15 15 15 14 13 13 15 13 )
arrCovLower=( 5 5 5 5 5 5 5 5 5 5 )
arrChr=( `seq 1 24` )

# iterate through each sample
for nSample in "${!arrSamples[@]}"; do 
	sSample=${arrSamples[$nSample]};
	nCovUpper=${arrCovUpper[$nSample]};
	nCovLower=${arrCovLower[$nSample]};

	# iterate through each chromosome
	for nChr in "${arrChr[@]}"; do 
		sChr=$sRef$sChrSuffix$nChr
		sChrDir=$sOutDir/$sSample/$sChr
		mkdir -p $sChrDir
        
        # perform variant filtering and masking in parallel
		( if [ ! -s $sChrDir/out_mask.bed.gz ];then 
            $BCFTOOLS view -r "$sChr" -e 'INFO/DP>'$nCovUpper' || INFO/DP<'$nCovLower'' $sVCFFolder/$sSample$sVCFSuffix | $vcfcaller $sChr $sChrDir/out_mask.bed.gz | gzip -c > $sChrDir/out.vcf.gz; 
          fi; \
		  # generate multihetsep input for msmc
          if [ ! -e $sChrDir/done.txt ]; then 
            $CONVERT --mask $sChrDir/out_mask.bed.gz $sChrDir/out.vcf.gz > $sChrDir/formsmc2.multihetsep.txt 2> $sChrDir/formsmc2.multihetsep.log && touch $sChrDir/done.txt; 
          fi; ) 2>$sChrDir/log.txt &
	done
done

# wait for all parallel jobs to finish
wait