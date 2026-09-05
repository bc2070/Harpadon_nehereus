# iterate through each bam file in the specified directory
for sSample in /data2/projects/dyao/pachycara/compare/gatk/pachycara/*.bam; do
        # extract base filename and sample name
        sBase=`basename $sSample`
        sName=${sBase/.bam/}
        
        # run gatk analysis script for each sample in the background
        source /data2/projects/dyao/pachycara/compare/gatk/pachycara/gatk.sh $sSample &
done
# wait for all background processes to complete
wait