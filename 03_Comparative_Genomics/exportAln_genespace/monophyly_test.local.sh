#!/bin/bash

# set total number of parallel partitions
TOTALPARTS=32
END=$(( $TOTALPARTS - 1 ))

# create directories for tree results and logs
mkdir -p genetrees_improved
mkdir -p logs

# launch monophyly test processes in parallel
for i in $( seq 0 $END ); do

php monophyly_test.php -N ${TOTALPARTS} -f ${i} > logs/monophylytest.$i.of.${TOTALPARTS}.log 2>&1  &

done

# wait for all parallel jobs to complete
wait
exit