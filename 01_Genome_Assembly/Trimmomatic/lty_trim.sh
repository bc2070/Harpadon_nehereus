# define paths for trimmomatic and adapters
trimjar=/data/software/trimmomatic-0.39/trimmomatic-0.39.jar
adapterfa=/data/software/trimmomatic-0.39/adapters/bgi_adapter.fa

# input and sample files
in1=d220900357a_1.fq.gz
in2=d220900357a_2.fq.gz
i=pachycara

# trim adapters and low-quality bases
java -jar $trimjar pe -threads 20 -phred33 $in1 $in2 $i.paired_1.fq.gz $i.unpaired_1.fq.gz $i.paired_2.fq.gz $i.unpaired_2.fq.gz illuminaclip:$adapterfa:2:30:10 leading:3 trailing:3 slidingwindow:4:15 minlen:36 > trim.$i.log 2>&1 &

# wait for completion
wait