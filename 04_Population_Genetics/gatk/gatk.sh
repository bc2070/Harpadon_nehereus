# set input bam and reference genome paths
bam=$1
genome=/data2/projects/dyao/pachycara/compare/gatk/pachycara/ref/pachycara_sort.fa
gatk=/data/software/gatk-4.2.1.0/gatk
CPU=10
sBase=`basename $1`
sSample=${sBase/.bam/}
outstem=$sSample
SCRATCHDIR=`pwd`/tmp
MAXDEPTH=250

# increase file handle limit for parallel processing
ulimit -n 99999 

# generate sequence dictionary
$gatk CreateSequenceDictionary -R $genome

mkdir -p $SCRATCHDIR

bam=`realpath $bam`
genome=`realpath $genome`

# step 1: sort bam file by coordinate
STEP=01.sortbam
if [ -f $STEP.done ]; then
    echo "$STEP done, skip...";
else
    samtools sort -@ $CPU -o $outstem.sorted.bam $bam >$STEP.log 2>&1 \
    && touch  $STEP.done
    if [ "$?" -ne "0" ]; then exit 1; fi
fi

# step 2: add readgroup tag to bam
STEP=02.addRG
if [ -f $STEP.done ]; then
    echo "$STEP done, skip...";
else
    $gatk --java-options '-Xmx16g' AddOrReplaceReadGroups I=$outstem.sorted.bam O=$outstem.RG.bam RGID=$outstem RGLB=$outstem RGPL=mgi RGSM=$outstem RGPU=$outstem CREATE_INDEX=True VALIDATION_STRINGENCY=SILENT TMP_DIR=$SCRATCHDIR >$STEP.log 2>&1 \
    && touch  $STEP.done
    if [ "$?" -ne "0" ]; then exit 1; fi
fi

# step 3: mark pcr duplicates
STEP=03.dedup
if [ -f $STEP.done ]; then
    echo "$STEP done, skip...";
else
    $gatk --java-options '-Xmx16g' MarkDuplicates MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=900 INPUT=$outstem.RG.bam OUTPUT=$outstem.dedup.bam ASSUME_SORTED=true METRICS_FILE=$outstem.dedup.metrics.txt VALIDATION_STRINGENCY=SILENT TMP_DIR=$SCRATCHDIR >$STEP.log 2>&1 \
    && samtools index $outstem.dedup.bam \
    && touch  $STEP.done
    if [ "$?" -ne "0" ]; then exit 1; fi
fi

# step 4: haplotype caller variant discovery
STEP=04.haplotypecaller
if [ -f $STEP.done ]; then
    echo "$STEP done, skip...";
else
    $gatk --java-options '-Xmx128g' HaplotypeCaller --native-pair-hmm-threads $CPU -I $outstem.dedup.bam -O $outstem.g.vcf -R $genome --max-reads-per-alignment-start $MAXDEPTH --minimum-mapping-quality 30 -ERC BP_RESOLUTION --dont-use-soft-clipped-bases true >$STEP.log 2>&1 \
    && touch  $STEP.done
    if [ "$?" -ne "0" ]; then exit 1; fi
fi

# step 5: compress output gvcf
STEP=05.compress
if [ -f $STEP.done ]; then
    echo "$STEP done, skip...";
else
    bgzip -@ $CPU $outstem.g.vcf > $STEP.log 2>&1 && tabix -p vcf $outstem.g.vcf.gz >> $STEP.log 2>&1 \
    && touch  $STEP.done
    if [ "$?" -ne "0" ]; then exit 1; fi
fi

# step 6: genotype gvcf
STEP=06.genotypegvcf
if [ -f $STEP.done ]; then
    echo "$STEP done, skip...";
else
    $gatk --java-options '-Xmx12g' GenotypeGVCFs -O $outstem.genotyped.g.vcf -R $genome -V $outstem.g.vcf.gz -all-sites true > $STEP.log 2>&1 \
    && touch  $STEP.done
    if [ "$?" -ne "0" ]; then exit 1; fi
fi

# step 7: compress final vcf
STEP=07.compress
if [ -f $STEP.done ]; then
    echo "$STEP done, skip...";
else
    bgzip -@ $CPU $outstem.genotyped.g.vcf > $STEP.log 2>&1 && tabix -p vcf $outstem.genotyped.g.vcf.gz >> $STEP.log 2>&1 \
    && touch  $STEP.done
    if [ "$?" -ne "0" ]; then exit 1; fi
fi