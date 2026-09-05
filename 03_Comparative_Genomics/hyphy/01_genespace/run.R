# set library path for genespace dependencies
.libPaths("/data/projects/rcui/R/x86_64-pc-linux-gnu-library/4.1")

# load genespace library
library(GENESPACE)

# define working directory
runwd <- file.path("/data2/projects/dyao/compare/hyphy/01_genespace/rundir")

# initialize genespace parameters
gpar <- init_genespace(
  genomeIDs = c("AnabasTestudineus", "AnarrhichthysOcellatus", "BassozetusSp", "BrotulaMultibarbata", "CebidichthysViolaceus", "DanioRerio", "DictyosomaTongyeongensis", "GadusMorhua", "GasterosteusAculeatus", "LarimichthysCrocea", "LutjanusErythropterus", "OreochromisNiloticus", "OryziasLatipes", "PachycaraSp", "PercaFlavescens", "PercaFluviatilis", "PholisGunnellus", "PholisNebulosa", "SanderLucioperca", "SinipercaChuatsi", "TakifuguRubripes", "ThunnusAlbacares", "XiphophorusMaculatus"),
  speciesIDs = c("Anabas_testudineus", "Anarrhichthys_ocellatus", "Bassozetus_sp", "Brotula_multibarbata", "Cebidichthys_violaceus", "Danio_rerio", "Dictyosoma_tongyeongensis", "Gadus_morhua", "Gasterosteus_aculeatus", "Larimichthys_crocea", "Lutjanus_erythropterus", "Oreochromis_niloticus", "Oryzias_latipes", "Pachycara_sp", "Perca_flavescens", "Perca_fluviatilis", "Pholis_gunnellus", "Pholis_nebulosa",  "Sander_lucioperca",  "Siniperca_chuatsi", "Takifugu_rubripes", "Thunnus_albacares", "Xiphophorus_maculatus"),
  versionIDs = c("1", "1", "1", "1", "1","1" , "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1"),
  ploidy = rep(1,23),
  diamondMode = "default",
  orthofinderMethod = "default",
  wd = runwd,
  nCores = 60,
  minPepLen = 30,
  gffString = "gff",
  pepString = "pep",
  path2orthofinder = "/opt/miniconda3/bin/orthofinder",
  path2diamond = "/opt/miniconda3/bin/diamond",
  path2mcscanx = "/data/software/MCScanX/",
  rawGenomeDir = file.path(runwd, "rawGenomes"))
  
# parse annotations
parse_annotations(
  gsParam = gpar,
  gffEntryType = "gene",
  gffIdColumn = "locus",
  gffStripText = "locus=",
  headerEntryIndex = 1,
  headerSep = " ",
  headerStripText = "locus=")

# run orthofinder analysis
gpar <- run_orthofinder(gsParam = gpar)

# perform synteny mapping
gpar <- synteny(gsParam = gpar)

# generate riparian plots
ripdat <- plot_riparianHits(gpar)

# generate pangenome analysis
pg <- pangenome(gpar)