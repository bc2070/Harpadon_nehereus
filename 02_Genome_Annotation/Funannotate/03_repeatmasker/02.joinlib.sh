# concatenate custom and external te libraries
cat pachycara-te-families.fa > all_te.fa
echo "" >>  all_te.fa
cat /data/projects/rcui/repbase/Libraries/actinopterygii_TE.fa >> all_te.fa

