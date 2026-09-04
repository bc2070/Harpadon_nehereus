# Protein Sequence Standardization & Preprocessing Pipeline

This module automates the cleaning, deduplication, and standardization of protein sequence data across multiple species. It is designed to prepare high-quality, non-redundant FASTA databases for downstream orthology inference (e.g., OrthoFinder) and phylogenomic analysis.

## 1. Pipeline Overview
1. Sequence Cleaning: Normalizes sequence headers, removes illegal characters, and standardizes FASTA formatting.
2. Redundancy Filtering: Extracts the longest isoform per gene to eliminate transcriptional redundancy while tracking isoform statistics.
3. Species Tagging: Appends unique species identifiers to sequence headers to prevent ID collisions during multi-species integration.
4. Database Consolidation: Merges processed sequences into a single, comprehensive multi-species protein database.

## 2. Input File Formats

### A. Raw Protein FASTA (*.longest_isoform.prot.fa)
The primary input file for each species, containing all annotated protein isoforms.
- Format: Standard FASTA (Header | Sequence)
- Example: 
  >XP_001234.1_isoform1 Description...
  MKAILVLVTLA...

### B. Species Directory Structure
The pipeline iterates through a specified directory where each subdirectory contains the raw protein FASTA.
- Format: /path/to/data/[SpeciesName]/[SpeciesName].longest_isoform.prot.fa

## 3. Output Files

### A. [Species].filtered.fa
- Description: Cleaned protein sequences containing only the longest isoform per gene.
- Formatting: IDs are cleaned of special characters (., :, | are replaced with _).

### B. [Species].filtered.tab
- Description: Metadata log tracking filtering decisions.
- Columns: GeneID, Len, TotalIsoforms, TranscriptCount, TranscriptID, Included (yes/no), FullHeader.

### C. allNCBIproteins.fa
- Description: The final master database containing concatenated, tagged sequences from all processed species.
- Format: >SpeciesName|CleanedGeneID

## 4. Usage Workflow

1. Initialization:
   Ensure all raw protein files are organized into their respective species directories under `00_species_forrelax/`.

2. Preprocessing & Tagging:
   Run the batch preparation script:
   ./prepareNCBIProteins.sh
   - This executes `preprocessAA.php` to filter for the longest isoform and `minreID.py` to assign unique species-specific tags.

3. Consolidation:
   The `prepareNCBIProteins.sh` script automatically triggers the final concatenation. The resulting `allNCBIproteins.fa` will be available for use as the primary input for OrthoFinder or other comparative genomic tools.

4. Quality Review:
   Inspect the generated `[Species].filtered.tab` files to verify that the filtering logic correctly identified the primary isoforms and to identify any potential issues with excessive transcriptional redundancy in specific species.