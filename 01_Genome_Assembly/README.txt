============================================================
PROJECT: Genome Assembly and Polishing Pipeline
============================================================

1. OVERVIEW
This pipeline performs de novo genome assembly using long-read sequencing (ONT), 
polishing with short-read data, and chromosome-level scaffolding using Hi-C.

2. PIPELINE STEPS

--- PART I: TRIMMING & ASSEMBLY ---
Trimmomatic/lty_trim.sh    : Quality control and adapter trimming for Illumina data.
NextDenovo/01.mkinput.sh   : Prepare ONT raw data (input.fofn).
NextDenovo/02.run_nextdenovo.sh : De novo assembly of raw ONT reads.

--- PART II: POLISHING & ALIGNMENT ---
NextPolish/shortreads.sh   : Prepare short-read data (sgs.fofn).
NextPolish/nextpolish.sh   : Polish assembly using both short and long reads.
bwa/bwa.sh                 : Map clean short reads to the genome for downstream analysis.

--- PART III: HIC SCAFFOLDING ---
HiC/juicer/prep.sh         : Prepare references and restriction sites for Hi-C.
HiC/3ddna/run3ddna.sh      : Perform chromosome-level scaffolding using Hi-C data.

3. DIRECTORY STRUCTURE
- 01_Genome_Assembly/
    - bwa/          : Alignment of NGS reads.
    - HiC/          : Hi-C scaffolding (Juicer & 3D-DNA).
    - NextDenovo/   : ONT-based genome assembly.
    - NextPolish/   : Assembly polishing pipeline.
    - Trimmomatic/  : NGS data preprocessing.