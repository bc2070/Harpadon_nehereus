.libPaths("/data/projects/rcui/R/x86_64-pc-linux-gnu-library/4.1")
library(GENESPACE)
runwd <- file.path("/data2/projects/dyao/compare/hyphy/01_genespace/rundir")

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
  
parse_annotations(
  gsParam = gpar,
  gffEntryType = "gene",
  gffIdColumn = "locus",
  gffStripText = "locus=",
  headerEntryIndex = 1,
  headerSep = " ",
  headerStripText = "locus=")

gpar <- run_orthofinder(gsParam = gpar)

gpar <- synteny(gsParam = gpar)


#arrCol <- rainbow(24);
#arrLabelGenomes <- c('HarpadonNehereus')

#regs <- data.frame(
 # genome = rep('HarpadonNehereus', 24),
 # chr =1:24)
ripdat <- plot_riparianHits(gpar)

#datInvert <- data.frame(genome="LarimichthysCrocea", chr=toupper(c('cm014885.1', 'cm014896.1', 'cm014882.1', 'cm014893.1', 'cm014886.1', 'cm014881.1','cm014902.1','cm014900.1')) )
#datInvert <- rbind(datInvert, data.frame(genome="CollichthysLucidus", chr=toupper(c('cm014081.1', 'cm014082.1', 'cm014083.1', 'cm014079.1', 'cm014095.1', 'cm014089.1', 'cm014094.1', 'cm014100.1', 'cm014101.1' ) ) ) );
#datInvert <- rbind(datInvert, data.frame(genome="NibeaAlbiflora", chr=toupper(c('cm024795.1', 'cm024790.1', 'cm024800.1', 'cm024791.1', 'cm024794.1', 'cm024796.1', 'cm024807.1' ,'cm024806.1', 'cm024805.1', 'cm024802.1') ) ));
#datInvert <- rbind(datInvert, data.frame(genome="LutjanusErythropterus", chr=toupper(c('cm034600.1','cm034606.1','cm034604.1','cm034607.1','cm034613.1') )));
#datInvert <- rbind(datInvert, data.frame(genome="CheilinusUndulatus", chr=toupper(c('nc_054865.1', 'nc_054868.1', 'nc_054874.1', 'nc_054871.1', 'nc_054882.1', 'nc_054875.1', 'nc_054876.1', 'nc_054887.1', 'nc_054886.1', 'nc_054888.1', 'nc_054878.1'))));
#datInvert <- rbind(datInvert, data.frame(genome="MicropterusSalmoides", chr=toupper(c('nw_024043372.1','nw_024044237.1','nw_024040374.1','nw_024040596.1','nw_024040152.1','nw_024044459.1','nw_024041039.1','nw_024041373.1','nw_024041484.1','nw_024040928.1'))));
#datInvert <- rbind(datInvert, data.frame(genome="SanderLucioperca", chr=toupper(c('NC_050175.1','NC_050176.1','NC_050178.1','NC_050177.1','NC_050183.1','NC_050180.1','NC_050182.1','NC_050174.1','NC_050185.1','NC_050187.1','NC_050188.1','NC_050189.1','NC_050195.1'))));
#datInvert <- rbind(datInvert, data.frame(genome="GasterosteusAculeatus", chr=toupper(c('nc_053214.1','nc_053218.1'))));

#datInvert <- NULL;

#ripdat <- plot_riparianHits(
#  gpar,onlyTheseRegions = regs, refChrCols = arrCol,minGenes2plot=50, invertTheseChrs = datInvert,
#  blackBg = F, chrFill = "orange",returnSourceData=T,
#  chrBorder = "grey", useOrder=F, labelTheseGenomes = arrLabelGenomes )


pg <- pangenome(gpar)
