
arrOutgroupSpp='Anabas_testudineus,Anarrhichthys_ocellatus,Brotula_multibarbata,Cebidichthys_violaceus,Danio_rerio,Dictyosoma_tongyeongensis,Gadus_morhua,Gasterosteus_aculeatus,Larimichthys_crocea,Lutjanus_erythropterus,Oreochromis_niloticus,Oryzias_latipes,Perca_flavescens,Perca_fluviatilis,Pholis_gunnellus,Pholis_nebulosa,Sander_lucioperca,Siniperca_chuatsi,Takifugu_rubripes,Thunnus_albacares,Xiphophorus_maculatus';
#arrOutgroupSpp='Cheilinus_undulatus';
arrUnusedClades="NA"; #c('Aplocheilidae', 'root'); #mark as unused clades "only for hyphy relax"
arrMarkUnusedCladeChildren='F'; #c(T , F);

#######################################################################
arrForegroundClades='Bassozetus_sp'; #mark as foreground
arrMarkForegroundChildren='T';

sTaxonRequirements="min_taxon_requirements_Basso.txt";

nMarkStyle='relax'; #either "codeml" or "relax"
sOutDIR="Relax_Basso";

mkdir -p $sOutDIR
Rscript labelbranches.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

#sOutDIR="Relax_Callopanchax_mrca";
#arrMarkForegroundChildren='F';
#mkdir -p $sOutDIR
#Rscript labelbranches.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

sOutDIR="Codeml_Basso";
arrMarkForegroundChildren='F';
nMarkStyle='codeml';
mkdir -p $sOutDIR
Rscript labelbranches.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

#sOutDIR="Codeml_Callopanchax_mrca";
#arrMarkForegroundChildren='F';
#mkdir -p $sOutDIR
#Rscript labelbranches.R $sOutDIR  $nMarkStyle  $sTaxonRequirements  $arrOutgroupSpp  $arrForegroundClades  $arrMarkForegroundChildren  $arrUnusedClades  $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &
########################################################################

wait
