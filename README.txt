PAPER TITLE: Genomic mechanisms underlying Bombay Duck's rapid population surge

ABSTRACT: Bombay duck (Harpadon nehereus), once a minor by-catch in the East China Sea, has bloomed into a dominant species, altering marine ecosystems. This study explored the genomic basis of its mysterious recent success via chromosome-level genome assembly, comparative and population genomics. The genome assemblies of H. nehereus and its closely related outgroup species Saurida undosquamis were of good quality, showing a 96.7%~96.8% BUSCO completeness. Population resequencing supports a single panmictic population throughout the coast of China. Expanded gene families, genes under intensified and positive selection are related to osmoregulation, hypoxia tolerance, immune function and reproduction. Recent selective sweeps are mostly related to immune response. These molecular signatures are consistent with long-term adaptations to a hypoxic, polluted and fluctuating environment. These findings suggest that species genomically preadapted to environments affected by global change can suddenly become new native invaders.


GENERAL INFORMATION

1. Title of Datasets: Bombay_Duck_Genomic_Data

2. Date of data collection: 2025-07-30

3. Geographic location of data collection: East China Sea (Bombay Duck, BD) and South China Sea (Brushtooth lizardfish, BL)

4. License information: MIT License (https://opensource.org/licenses/MIT)

5. DOI for data and code repository: 10.5281/zenodo.22291906


DATA & FILE OVERVIEW

1. File List:
    01_Genome_Assembly/: DNA filtering, assembly scripts, and Hi-C scaffolding pipeline.
    02_Genome_Annotation/: Repeat masking, gene model generation, and functional annotation scripts.
    03_Comparative_Genomics/: Orthology analysis, phylogeny construction, and selection tests.
    04_Population_Genetics/: SNP calling workflow (GATK), PCA, Admixture, PSMC, and ROH analysis.
    05_Functional_Analysis/: Selective sweep detection (diploS/HIC) and deleterious variant assessment (SnpEFF).

2. Relationship between files:
    The analysis consists of independent, modular scripts. Users should execute them sequentially according to the logical order of the directories (01 to 05). Please ensure file paths in each script are updated to match your local file system.

3. Additional related data:
    The BD genome assembly and population resequencing data are available in the China National GeneBank DataBase (CNGBdb) CNSA under the accession number CNP0007843. The BL genome assembly and raw data are deposited in CNGBdb CNSA under the accession number CNP0007838.
Additionally, sequencing data related to the BD genome assembly have been deposited in the National Center for Biotechnology Information (NCBI) BioProject database under the following accession numbers: PRJNA784345 (Hi-C data), PRJNA784315 (NGS data), and PRJNA784648 (PacBio HiFi data).


4. Are there multiple versions of the dataset? No


METHODOLOGICAL INFORMATION

1. Description of methods:
    Methods include de novo genome assembly using long reads and Hi-C scaffolding. Gene models were predicted via integrated RNA-seq evidence. Comparative genomics were used to investigate evolutionary history. Population dynamics were assessed using 48 resequenced individuals, GATK-based SNP calling, and historical demographic inference (PSMC). Recent selective sweeps were identified using CNN-based diploS/HIC.

2. Instrument- or software-specific information:
    - Primary Tools: NextDenovo (v2.5.0), NextPolish (v1.4.1), BWA (v0.7.8), Funannotate (v1.8.9), OrthoFinder (v2.3.3), CAFE5 (v5.0), HyPhy (v2.5.10), GATK (v4.2.1.0), PSMC (v0.6.5), diploS/HIC (v1.0), SnpEFF (v5.1d).
    - R Packages: ggplot2 (v3.5.1), BEDMatrix (v2.0.3), popkin (v1.3.23), org.Dr.eg.db (v3.14.0), org.Hs.eg.db (v3.14.0), clusterProfiler (v4.2.2).
    - Environment: Analyses were performed on a Linux cluster using Conda environments.
