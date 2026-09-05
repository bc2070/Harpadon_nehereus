<?php
// define working directory
$sRunDir = "rundir";

// get species name and input file from command line arguments
$sSp_Prot = ($argv);
$sScfPrefix = ""; // prefix to be removed from scaffold names
$sSp = $sSp_Prot[1];
$sVersion = "1";
$sLongestIsoformProt = $sSp_Prot[2];

// setup output directory
$sWD = "$sRunDir/rawGenomes/$sSp/$sVersion/annotation";
exec("mkdir -p $sWD");

// open pipes for gff and fasta output
$hGFF = false;
if ($sScfPrefix !='') {
	$hGFF = popen("sort -k1,1n -k4,4n | gzip -c > $sWD/$sSp.gene.gff.gz", 'w');
} else {
	$hGFF = popen("sort -k1,1 -k4,4n | gzip -c > $sWD/$sSp.gene.gff.gz", 'w');
}

$hFas = popen("gzip -c > $sWD/$sSp.pep.fa.gz", 'w');

// open input protein file
$hIn = popen("zcat -f $sLongestIsoformProt", 'r');

// process lines
while(false!== ($sLn = fgets($hIn) )) {
	$sLn = trim($sLn);
	if ($sLn == '') {
		continue;
	}

	// parse header lines
	if ($sLn[0] == '>') {
		$arrF = explode(' ', substr($sLn, 1));
		$sSeqName = $arrF[0];
		$sSeqName = preg_replace('/[:|]/', '_', $sSeqName);
		$sPos = $arrF[count($arrF)-1];
		
		// extract genomic location information
		preg_match('/([^:]+):([^-]+)-([^(]+)\\((\\S)\\)/', $sPos, $arrM);
		if (count($arrM) != 5) {
			die("Failed to parse header: $sLn\n");
		}

		// write gff entry
		list($sChr, $nStart, $nEnd, $sOrient) = array_slice($arrM, 1);
		$sChr = str_replace($sScfPrefix, '', $sChr);
		fwrite($hGFF, "$sChr\tfunannotate\tgene\t$nStart\t$nEnd\t\t$sOrient\t\tlocus=$sSeqName\n");
		fwrite($hFas, ">$sSeqName\n");
	} else {
		// write protein sequence
		$sLn = str_replace('*', '', $sLn);
		fwrite($hFas, $sLn."\n");
	}

	
}
?>