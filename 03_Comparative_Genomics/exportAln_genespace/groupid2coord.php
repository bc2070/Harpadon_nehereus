<?php
// input and output configuration
$sOrtho = "genespace.orthogroups.txt";
$sGFF = "/data/projects/rcui/bahaha_assembly/release1.0/annotations_orthofinder_symbols/btp.longest.addedUPhO.genesymbol2.spgeneid.gff3";
$nCol = 3; // column index for target transcript id in orthogroups file
$sOut = "groupid2coord.txt";

// load genomic coordinates from gff file
$h = fopen($sGFF, 'r');
$arrCoords = array();
while(false !== ($sLn = fgets($h))) {
	$sLn = trim($sLn);
	if ($sLn == '' || $sLn[0] =='#') continue;

	$arrF = explode("\t", $sLn);
	// filter for mrna entries only
	if ($arrF[2] != "mRNA") continue;

	// extract transcript id from gff attributes
	preg_match('/ID=([^;]+)/', $arrF[8], $arrM);
	if (count($arrM)!=2) continue;

	$sID = trim($sID = $arrM[1]);
	$sID = str_replace('.', '_', $sID);
    // store sequence id and start/end coordinates
	$arrCoords[$sID] = array($arrF[0], $arrF[3]-1, $arrF[4]);
}

// process orthogroup data and map to coordinates
$hO = fopen($sOut, 'w');
$hOrth = fopen($sOrtho, 'r');

while(false !== ($sLn = fgets($hOrth))) {
	$sLn = trim($sLn);
	if ($sLn == '') continue;

	$arrF = explode("\t", $sLn);
	if ($arrF[0] == 'OrthoID') continue;
    
    // extract rna identifier from the specified column
	list($s1, $s2, $sRNAID) = explode("|", $arrF[$nCol]);

	if (!array_key_exists($sRNAID, $arrCoords)) {
		die("$sRNAID not found in gff3\n");
	}

    // write coordinate output mapping to group identifier
	fwrite($hO, implode("\t", $arrCoords[$sRNAID])."\t".$arrF[0]."\n");
}
?>