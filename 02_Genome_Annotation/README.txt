============================================================
PROJECT: Genome Annotation & Comparative Genomics Pipeline
============================================================

1. OVERVIEW
This repository contains workflows for structural and functional genome 
annotation, as well as comparative analysis through orthogroup mapping.

2. PIPELINE STEPS

--- PART I: FUNANNOTATE GENOME ANNOTATION ---
01_cleangenome/         : Prepare and standardize raw genome assembly.
02_repeatmodeler/       : Build and identify repetitive element libraries.
03_repeatmasker/        : Perform soft-masking of repetitive regions.
04_funannotate/         : Standard gene prediction (Train/Predict/Update).
05_funannotate_miniprot/: Refine gene models using Miniprot alignments.

--- PART II: ORTHOGROUP ANNOTATION ---
make_genesymbol_table_*.php : Extract gene symbols/descriptions from 
                              Ensembl or NCBI GFF3 files.
assigngenesymbol_orthofinder.php : Map functional annotations to 
                                   OrthoFinder orthogroup results.

3. DIRECTORY STRUCTURE
- Funannotate/
    - Contains full annotation pipeline: from cleaning and masking to 
      structural gene prediction using transcriptome and protein evidence.
- assigngenesymbols_orthofinder/
    - Contains tools for functional annotation integration, mapping 
      extracted gene symbols to orthogroups for downstream analysis.