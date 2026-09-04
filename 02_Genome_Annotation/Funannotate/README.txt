PROJECT: Pachycara Genome Annotation Pipeline

1. OVERVIEW
This pipeline performs de novo genome annotation for the Pachycara genome using 
the Funannotate framework, incorporating transcriptomic evidence (Trinity), 
protein evidence, and repetitive element masking.

2. PIPELINE STEPS

--- PART I: PRE-PROCESSING & REPEAT MASKING ---
01_cleangenome/    : Clean, sort, and standardize the raw genome assembly.
02_repeatmodeler/  : Build TE database and identify repetitive elements.
03_repeatmasker/   : Create soft-masked genome using custom and RepBase libraries.

--- PART II: FUNANNOTATE GENE PREDICTION ---
04_funannotate/    : Standard annotation pipeline.
   - 1_train.sbatch  : Optimize gene predictors using PASA and transcript data.
   - predict.sbatch  : Execute gene prediction (Augustus/EVM) with evidence weights.
   - update.sbatch   : Refine gene models and include alternative transcripts.

--- PART III: MINIPROT-BASED REFINEMENT ---
05_funannotate_miniprot/ : Enhanced annotation using Miniprot alignments.
   - 1_train.sbatch  : Retrain models with Miniprot-derived transcript assemblies.
   - predict.sbatch  : Final gene prediction with adjusted protein evidence.
   - update.sbatch   : Finalize and update models to produce high-confidence sets.