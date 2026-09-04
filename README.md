## Study Title
Genomic mechanisms underlying Bombay Duck's rapid population surge
## Summary
This repository contains the bioinformatic scripts used to assemble the Bombay duck (BD) genome and analyze its evolutionary history and population dynamics compared to the Brushtooth lizardfish (BL).
## Workflow & Usage
The analysis is composed of independent, modular scripts. Users should execute them sequentially according to the logical order of the directories. Execution steps:
Assembly: Run scripts in 01_Genome_Assembly/ to generate and polish the genome.
Annotation: Run 02_Genome_Annotation/ scripts to perform repeat masking and gene prediction.
Comparative: Use 03_Comparative_Genomics/ for phylogenomics and selection testing.
Population: Use 04_Population_Genetics/ for SNP calling and demography.
Functional: Use 05_Functional_Analysis/ for sweep detection and variant impact analysis.
Please ensure the paths in each script are updated to match your local file system before execution.
## Software & Versions
Primary Tools: NextDenovo (v2.5.0), NextPolish (v1.4.1), BWA (v0.7.8), Funannotate (v1.8.9), OrthoFinder (v2.3.3), CAFE5 (v5.0), HyPhy (v2.5.10), GATK (v4.2.1.0), PSMC (v0.6.5), diploS/HIC (v1.0), SnpEFF (v5.1d).
R Packages: ggplot2 (v3.5.1), BEDMatrix (v2.0.3), popkin (v1.3.23), org.Dr.eg.db (v3.14.0), org.Hs.eg.db (v3.14.0), clusterProfiler (v4.2.2).
Environment: Analyses were performed on a Linux cluster using Conda environments.
## Directory Structure
01_Genome_Assembly/: DNA filtering, assembly, and Hi-C scaffolding.
02_Genome_Annotation/: Repeat masking and gene model generation.
03_Comparative_Genomics/: Orthology, phylogeny, and selection (BUSTED-MH/RELAX).
04_Population_Genetics/: SNP calling, PCA, Admixture, PSMC, and ROH analysis.
05_Functional_Analysis/: Selective sweep (diploS/HIC) and deleterious variant assessment.
## License
This code is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
