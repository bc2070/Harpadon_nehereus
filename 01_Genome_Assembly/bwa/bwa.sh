# cpu configuration and reference path
cpu=30
ref=/data/projects/lwang/genome/lty_genome/resequencing/01.SNP_calling/01.ref/lty_genome.upper.fasta

# process clean read pairs, short reads
for sr1 in /data/projects/lwang/genome/lty_genome/resequencing/00.data/02.cleandata/lg_pop/*_1_clean.fq.gz; do
    # extract sample identifier
    sdir=`dirname $sr1`
    sbase=`basename $sr1`
    sample=${sbase/_1_clean.fq.gz/}
    sr2=${sdir}/${sample}_2_clean.fq.gz

    # bwa alignment, bam conversion, and coordinate sorting
    ( bwa mem -t $cpu $ref $sr1 $sr2 \
    | samtools view -u - | samtools sort - -m 10g -o $sample.bam ) > $sample.log 2>&1 &
done

# wait for all background jobs
wait
