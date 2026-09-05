# define outgroup and clade settings
arrOutgroupSpp='Anabas_testudineus,Anarrhichthys_ocellatus,Brotula_multibarbata,Cebidichthys_violaceus,Danio_rerio,Dictyosoma_tongyeongensis,Gadus_morhua,Gasterosteus_aculeatus,Larimichthys_crocea,Lutjanus_erythropterus,Oreochromis_niloticus,Oryzias_latipes,Perca_flavescens,Perca_fluviatilis,Pholis_gunnellus,Pholis_nebulosa,Sander_lucioperca,Siniperca_chuatsi,Takifugu_rubripes,Thunnus_albacares,Xiphophorus_maculatus';
arrUnusedClades="NA"; 
arrMarkUnusedCladeChildren='F'; 

# configure foreground branches for selection analysis
arrForegroundClades='Pachycara_sp'; 
arrMarkForegroundChildren='T';
sTaxonRequirements="min_taxon_requirements_Pachy.txt";

# execute relax analysis
nMarkStyle='relax'; 
sOutDIR="Relax_Pachy";
mkdir -p $sOutDIR
Rscript labelbranches.R $sOutDIR $nMarkStyle $sTaxonRequirements $arrOutgroupSpp $arrForegroundClades $arrMarkForegroundChildren $arrUnusedClades $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

# execute codeml analysis
sOutDIR="Codeml_Pachy";
arrMarkForegroundChildren='F';
nMarkStyle='codeml';
mkdir -p $sOutDIR
Rscript labelbranches.R $sOutDIR $nMarkStyle $sTaxonRequirements $arrOutgroupSpp $arrForegroundClades $arrMarkForegroundChildren $arrUnusedClades $arrMarkUnusedCladeChildren > $sOutDIR/log.txt &

# wait for all background tasks to finish
wait