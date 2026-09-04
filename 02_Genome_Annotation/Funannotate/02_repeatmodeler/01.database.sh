dustmasker -in ./pachycara_sort.fa -infmt fasta -parse_seqids -outfmt maskinfo_asn1_bin -out pachycara.asnb

makeblastdb -in ./pachycara_sort.fa -input_type fasta -dbtype nucl -parse_seqids -mask_data pachycara.asnb -out pachycara

