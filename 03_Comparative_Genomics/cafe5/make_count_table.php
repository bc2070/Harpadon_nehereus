<?php
// input and output paths
$sin = "/data/projects/rcui//bahaha_assembly/synteny/genespace/morespp/rundir/orthofinder/results_mar18/phylogenetic_hierarchical_orthogroups/n0.tsv";
$sout = "orthogroup.counts.tsv";

$bheaderread = false;
$h = fopen($sin, 'r');
$ho = fopen($sout, 'w');

// process orthogroup file
while(false !== ($sln = fgets($h)) ) {
	$sln = trim($sln , "\n");
	if ($sln == '') continue;
	$arrf = explode("\t", $sln);
	
	// handle header
	if (!$bheaderread) {
		$arrspp = array_slice($arrf, 3);
		foreach($arrspp as &$spp) $spp = trim($spp);
		fwrite($ho, "desc\torthogroup\t".implode("\t", $arrspp )."\n");
		$bheaderread = true;
		continue;
	}

	// count genes per orthogroup
	$arrcounts = array();
	for($ncol=3; $ncol<count($arrf); $ncol++) {
		$arrg = explode(',', trim($arrf[$ncol]) ) ;
		$ncount = 0;
		foreach($arrg as $sg) {
			if (trim($sg) !='') $ncount++;
		}
		$arrcounts[] = $ncount;
	}

	// write counts to output
	fwrite($ho, "(null)\t".trim(str_replace('n0.','', $arrf[0]) )."\t".implode("\t", $arrcounts)."\n");
}
?>