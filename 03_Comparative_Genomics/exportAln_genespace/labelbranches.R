library(ape)
library(phytools)

# process command line arguments for analysis configuration
args = commandArgs(trailingOnly=TRUE)
nArgCount <- 0

# parse parameters: output directory, style, requirements, outgroups, foreground, and clade markers
if (length(args) >= (nArgCount <- nArgCount + 1)) sOutDIR <- args[nArgCount]
if (length(args) >= (nArgCount <- nArgCount + 1)) nMarkStyle <- args[nArgCount]
if (length(args) >= (nArgCount <- nArgCount + 1)) sTaxonRequirements <- args[nArgCount]
if (length(args) >= (nArgCount <- nArgCount + 1)) arrOutgroupSpp <- unlist(strsplit(args[nArgCount] , split = ","))
if (length(args) >= (nArgCount <- nArgCount + 1)) arrForegroundClades <- unlist(strsplit(args[nArgCount] , split = ","))
if (length(args) >= (nArgCount <- nArgCount + 1)) arrMarkForegroundChildren <- as.logical(unlist(strsplit(args[nArgCount] , split = ",")))

if (length(args) >= (nArgCount <- nArgCount + 1)) {
  arrUnusedClades <- c()
  if (args[nArgCount] != 'NA') arrUnusedClades <- unlist(strsplit(args[nArgCount] , split = ","))
}
if (length(args) >= (nArgCount <- nArgCount + 1)) arrMarkUnusedCladeChildren <- as.logical(unlist(strsplit(args[nArgCount] , split = ",")))

# setup environment and load definitions
dir.create(sOutDIR, recursive = T , mode = "0777")
sMonophylyDef <- "monophyly_desc.txt"
datTaxonReq <- read.table(sTaxonRequirements , header=T, stringsAsFactors = F)

# helper to recursively build clade hierarchy tree
fnBuildTree <- function(sNodeName, datMap, arrIncludeTaxon) {
  arrTree <- list()
  if ( !( sNodeName %in% datMap$V1) ) return(paste("Node name", sNodeName," undefined\n"))
  arrChilds <- unlist(strsplit(datMap[datMap$V1==sNodeName , 'V2'], ','))
  for( sChild in arrChilds ) {
    sChild <- trimws(sChild)
    if ( substr(sChild , 1,1) == '*' ) { 
      sChildNodeName <- substr(sChild, 2, nchar(sChild) )
      oChildNode <- fnBuildTree(sChildNodeName , datMap , arrIncludeTaxon)
      if ( length(oChildNode) > 0 ) arrTree[[sChildNodeName]] <- oChildNode
    } else {
      if ( isTRUE(arrIncludeTaxon) || (sChild %in% arrIncludeTaxon) ) arrTree[sChild] <- T
    }
  }
  return(arrTree)
}

# count valid taxa within a specific clade
fnGetCountForTaxon <- function(sTaxon, lsGroup) {
  nCounts <- 0
  for(sName in names(lsGroup) ) {
    if (sName == sTaxon) {
      if ( isTRUE(lsGroup[[sName]]) ) return(1) else {
        for(sChildName in names(lsGroup[[sName]]) ) nCounts <- nCounts + fnGetCountForTaxon(sChildName , lsGroup[[sName]])
        return(nCounts)
      }
    } else nCounts <- nCounts + fnGetCountForTaxon(sTaxon , lsGroup[[sName]])
  }
  return(nCounts)
}

# collect all descendant terminal tips
fnGetAllDescendantTips <- function(sTaxon, lsGroup)  {
  arrTips <- c()
  for(sName in names(lsGroup) ) {
    if (sName == sTaxon) {
      if ( isTRUE(lsGroup[[sName]]) ) return(sName) else {
        for(sChildName in names(lsGroup[[sName]]) ) arrTips <- c(arrTips, fnGetAllDescendantTips(sChildName , lsGroup[[sName]]))
        return(arrTips)
      }
    } else arrTips <- c(arrTips , fnGetAllDescendantTips(sTaxon , lsGroup[[sName]]))
  }
  return(arrTips)
}

# load and filter phylogenetic tree data
arrAUResults <- Sys.glob("genetrees_improved/ret_part*.txt")
datAU <- do.call(rbind, lapply(arrAUResults, function(f) read.table(f, header=F, fill=T, stringsAsFactors=F)))
colnames(datAU) <- c('GeneId' , 'nTaxa' , 'status' , 'obs', 'au' , 'tree_free', 'tree_constraint')
datAUFilter <- datAU[datAU$status=='accepted_monophyly', ]

# process each gene tree
for(nR in 1:nrow(datAUFilter)) {
  sGeneId <- datAUFilter[nR, 'GeneId']
  sTree <- datAUFilter[nR, 'tree_constraint']
  oTree <- tryCatch({read.tree(text=sTree)}, error=function(e) return(F))
  if (isFALSE(oTree) || is.null(oTree)) next
  
  oTree <- unroot(oTree)
  arrOutgroupSppFound <- intersect(arrOutgroupSpp, oTree$tip.label)
  if (length(arrOutgroupSppFound) == 0) next
  
  # root tree using identified outgroup
  oTree <- if (length(arrOutgroupSppFound) == 1) reroot(oTree, which(oTree$tip.label == arrOutgroupSppFound[1])) else reroot(oTree, findMRCA(oTree, tips=arrOutgroupSppFound))
  oTree$edge.length <- NULL
  oClades <- list(root = fnParseMonoDesc(sMonophylyDef , oTree$tip.label))
  
  # validate taxonomic requirements
  bValidated <- T
  for(nR2 in 1:nrow(datTaxonReq)) {
    if (fnGetCountForTaxon(datTaxonReq[nR2, 1] , oClades) < datTaxonReq[nR2, 2]) bValidated <- F
  }
  if (!bValidated) next
  
  # apply labeling based on selected mark style (relax or codeml)
  if (nMarkStyle == 'relax') {
    # implementation of relax branch/node labeling
    # omitted internal logic for brevity
  } else if (nMarkStyle == 'codeml') {
    # implementation of codeml style #1 branch labeling
  }
  
  write.tree(oTree , file=paste(sOutDIR ,'/', sGeneId , '.txt' , sep=""))
}