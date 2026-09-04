#!/bin/bash
#do gatk.sh for each sample.bam file in /data/projects/zwang/m.op/GATK/macro_for_add
for sSample in /data2/projects/dyao/pachycara/compare/gatk/pachycara/*.bam; do
        sBase=`basename $sSample`
        sName=${sBase/.bam/}
        source /data2/projects/dyao/pachycara/compare/gatk/pachycara/gatk.sh $sSample &
done;
wait
