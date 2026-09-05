# define input orthofinder gene count file
IN=/data/projects/dyao/Data/Harpadon_nehereus/synteny/genespace/rundir/orthofinder/Results_Feb09/Orthogroups/Orthogroups.GeneCount.tsv

# format table for cafe by adding description column
cat $IN | cut -f1-12 | awk '{if ($1=="Orthogroup") {print "Desc\t"$0 } else {print "(null)\t"$0 } }' > orthogroups.genecount.txt
