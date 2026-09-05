#!/bin/bash

#SET THIS TO THE CORRECT NUMBER
TOTALPARTS=6
END=$(( $TOTALPARTS - 1 ))

# create directories for output and logs
mkdir -p output
mkdir -p logs

# launch parallel export processes
for i in $( seq 0 $END ); do 

php exportAln_multiref_withorigseq.php -N ${TOTALPARTS} -f ${i} > logs/export.${i}.log 2>&1 &

# wait for all background processes to finish
done
wait
exit

