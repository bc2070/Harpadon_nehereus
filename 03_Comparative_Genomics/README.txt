============================================================
PROJECT: Comparative Evolutionary Genomics & Phylogenetics
============================================================

1. OVERVIEW
This repository provides a comprehensive suite for evolutionary analysis, 
covering gene family expansion (CAFE5), synteny-based ortholog extraction, 
molecular evolution (selection/divergence time), and functional enrichment.

2. PIPELINE STEPS

--- PART I: GENE FAMILY EVOLUTION (CAFE5) ---
Tools for converting OrthoFinder orthogroups into gene count tables, 
estimating global error models, and performing gamma-distributed rate 
modeling to detect gene family expansions/contractions.

--- PART II: ORTHOLOG EXTRACTION & ALIGNMENT ---
Pipeline for extracting orthologous sequences from genome assemblies, 
performing codon-aware alignments, and conducting branch-site selection 
tests via PAML and HyPhy.

--- PART III: SELECTION & FUNCTIONAL ENRICHMENT (HyPhy) ---
Synteny-guided orthology clustering (GeneSpace), phylogenetic tree inference 
(RAxML), lineage-specific selection testing (RELAX), and GO term enrichment.

--- PART IV: DIVERGENCE TIME ESTIMATION (MCMCTree) ---
Workflow for estimating species divergence times using PAML's MCMCTree, 
including data partitioning by codon position and approximate likelihood calculation.

3. DIRECTORY STRUCTURE
- cafe5/                  : CAFE5 gene family evolution analysis.
- exportAln_genespace/    : Ortholog extraction and codon-aware alignment.
- hyphy/                  : Phylogenetic inference and selection (RELAX/GO) analysis.
- MCMCTree/               : Molecular clock/divergence time estimation pipeline.
