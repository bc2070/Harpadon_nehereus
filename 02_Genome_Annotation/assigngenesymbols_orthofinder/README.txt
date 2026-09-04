# OrthoFinder Gene Symbol & Annotation Pipeline

This pipeline automates the functional annotation of OrthoFinder Hierarchical Orthogroups (HOGs). It processes species-specific GFF3 files to generate gene symbol mappings and subsequently assigns representative gene symbols and descriptions to each orthogroup based on consensus frequency and naming conventions.

## 1. Pipeline Overview
1. Mapping Generation: Extracts gene symbols and product descriptions from GFF3 files (compatible with both Ensembl and NCBI formatting).
2. Orthogroup Processing: Integrates the OrthoFinder 'n0.tsv' file with generated mapping files.
3. Functional Assignment: Filters ambiguous terms, identifies the most frequent gene symbol within each HOG, and selects the most informative description.

## 2. Input File Formats

### A. gffs.txt (or gffs1.txt)
Defines the mapping between taxon names and their corresponding GFF3 files.
- Format: Tab-delimited (TaxonName [Tab] PathToGFF3)
- Example:
  HarpadonNehereus    /data/projects/data/Harpadon_nehereus.gff3
  LiparisTanakae      /data/projects/data/Liparis_tanakae.gff3

### B. n0.tsv
The primary OrthoFinder phylogenetic hierarchical orthogroups output.
- Format: Standard OrthoFinder output (Tab-delimited, contains HOG ID in the first column followed by gene lists per species).

## 3. Output Files

### A. [TaxonName].id2genesymbol.map.txt
- Description: Intermediate mapping files generated for each species.
- Columns: ProteinID, GeneSymbol, Description.

### B. orthofinder_genesymbols.tsv
- Description: The final annotated table for all orthogroups.
- Columns:
  - HOG/OG info: Original OrthoFinder metadata.
  - GeneSymbol: The representative gene name selected by the algorithm.
  - Description: The most descriptive functional annotation for the HOG.
  - AllGeneSymbols: A pipe-delimited list of all gene symbols found in the HOG.
  - AllDescriptions: A pipe-delimited list of unique descriptions found in the HOG.

## 4. Usage Workflow

1. Generate Mapping Tables:
   Depending on your GFF3 source, run the appropriate parser:
   - For Ensembl-style GFFs: `php make_genesymbol_table_ensemblgff.php`
   - For NCBI-style GFFs: `php make_genesymbol_table_ncbigff.php`
   *This will output one `.id2genesymbol.map.txt` file per species.*

2. Annotate Orthogroups:
   Ensure your `n0.tsv` file is correctly referenced in `assigngenesymbols_orthofinder.php`. Execute:
   `php assigngenesymbols_orthofinder.php`

3. Review Results:
   Check `orthofinder_genesymbols.tsv`. The algorithm uses a frequency-based voting mechanism to determine the most representative `GeneSymbol` for each orthogroup.

## 5. Notes
- Filtering: The pipeline automatically excludes gene symbols containing "/unknown/", those starting with "loc" (often predicted loci), or those containing ":" to ensure high-quality annotation.
- Memory: For extremely large datasets, ensure the PHP `memory_limit` is sufficient (e.g., set `memory_limit = 2G` in `php.ini`).