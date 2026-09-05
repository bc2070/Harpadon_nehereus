# apply softmasking to assembly using gff file
bedtools maskfasta -soft -fi scf.fa -bed scf.fa.out.gff -fo scf.softmasked.fa

