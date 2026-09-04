# Comparative Orthology & Evolutionary Analysis Pipeline

This pipeline automates the process of extracting homologous sequences from multiple genomes, performing sequence quality control (QC), validating phylogenetic constraints, and preparing branched-labeled trees for evolutionary selection analysis (e.g., HYPHY RELAX or PAML codeml).

## 1. Pipeline Overview
1. Data Preparation: Standardizing gene identifiers from OrthoFinder/GeneSpace.
2. Sequence Extraction: Extracting CDS/AA sequences based on GFF3 annotations, applying QC filters (trimming, mask gaps, exclude stops).
3. Monophyly Testing: Using AU-Test to validate if each gene's phylogeny conforms to the predefined species tree constraints.
4. Branch Labeling: Automatically assigning foreground/background labels to phylogenetic trees for downstream evolutionary models.

## 2. Input File Formats

### A. genomes.txt
Defines the mapping between reference names and specific genome data.
- Format: Tab-delimited (RefName | SpeciesName | PseudoGenome.fa | CovBlackList.txt)
- Example:
  RefName    SpeciesName    PseudoGenome.fa    CoverageBlacklist.txt
  BassoRef   Bassozetus     Basso.fa           Basso_cov.txt

### B. genespace.orthogroups.txt
The central mapping file identifying orthologs across species.
- Format: Tab-delimited header with species names.
- Example:
  OrthoID    GeneSymbol    GeneName    Bassozetus                  Danio_rerio
  Group_1    symbol_a      name_a      Bassozetus|gene01|rna01     Danio|gene05|rna05

### C. monophyly_desc.txt
Defines the expected hierarchical tree topology for monophyly testing.
- Format: ParentNode [Tab] Comma-separated children (Use '*' for sub-nodes).
- Example:
  root              *Actinopterygii,*Outgroups
  Actinopterygii    Bassozetus,Brotula,Gadus
  Outgroups         Danio_rerio

### D. outgroups.txt
Lists species used for tree rooting.
- Format: SpeciesName [Tab] PathToCDS.fasta

## 3. Output Files

### A. output/ret_partX_of_Y_cleanDNA.fasta
- Description: High-quality, QC-passed DNA alignment sequences for each orthogroup.

### B. genetrees_improved/ret_partX.of.Y.txt
- Description: Result of the AU-Test (Approximately Unbiased test).
- Columns: GeneId, N_Taxa, Status, LnL_Diff, AU_Pvalue, FreeTree, ConstraintTree.

### C. [Relax/Codeml]_BTP/*.txt
- Description: Final Newick tree files with branch labels (e.g., {T} for foreground, {R} for reference) ready for HYPHY/PAML.

## 4. Usage Workflow

1. Data Integration:
   Run `genespace2orthologtable.php` to generate the standardized `genespace.orthogroups.txt`.

2. Sequence Processing:
   Modify `export.local.sh` (set TOTALPARTS) and run `./export.local.sh`. This produces cleaned FASTA files in the `output/` directory.

3. Phylogeny Validation:
   Run `./monophyly_test.local.sh` to perform RAxML tree inference and AU-Tests. Only genes that pass monophyly constraints are retained.

4. Branch Labeling:
   Configure the foreground/background species in `labelbranches.all.Basso.sh` and run it. This uses `labelbranches.R` to parse trees and apply the required branch labels.
