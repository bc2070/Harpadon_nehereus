PROJECT: CAFE5 Gene Family Evolution Analysis

1. OVERVIEW
This pipeline utilizes CAFE5 to analyze gene family expansions and contractions 
across species based on OrthoFinder results, including error model estimation 
and gamma distribution rate modeling.

2. PIPELINE STEPS

--- PART I: DATA PREPARATION ---
make_count_table.php       : Convert OrthoFinder orthogroup files into CAFE-ready 
                             gene count tables.
convert_ortherfinder_count_table.sh : Format count table structure for CAFE input.

--- PART II: MODEL ESTIMATION & ANALYSIS ---
err.est.sh                 : Estimate the global error model parameters for 
                             gene count data.
runk2-6.sh                   : Run CAFE5 iterative modeling with a specified number 
                             of gamma rate categories (k=2-6).
stats.sh                   : Summarize and extract gamma distribution results 
                             from multiple execution directories.