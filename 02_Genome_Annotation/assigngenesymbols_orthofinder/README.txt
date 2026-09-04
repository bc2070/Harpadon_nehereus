============================================================
PROJECT: OrthoFinder Gene Symbol & Annotation Mapping
============================================================

1. OVERVIEW
This pipeline extracts gene symbols and functional descriptions 
from GFF3 files and integrates them into OrthoFinder results, 
enabling the systematic annotation of orthogroups.

2. PIPELINE STEPS

--- PART I: GFF DATA EXTRACTION ---
make_genesymbol_table_ensemblgff.php : Extracts gene symbols/descriptions 
                                       from Ensembl-style GFF3 files.
make_genesymbol_table_ncbigff.php    : Extracts gene symbols/descriptions 
                                       from NCBI-style GFF3 files.

--- PART II: ORTHOGROUP INTEGRATION ---
assigngenesymbol_orthofinder.php     : Maps extracted gene symbols to 
                                       OrthoFinder n0.tsv orthogroups to 
                                       assign a consensus gene symbol per group.