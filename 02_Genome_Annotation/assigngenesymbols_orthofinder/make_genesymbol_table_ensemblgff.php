<?php
// input file containing taxon names and gff paths
$slist = "gffs.txt";
$hlist = fopen($slist, 'r');

while( false !== ($sln = fgets($hlist) ) ) {
	$sln = trim($sln);
	if ($sln == '') continue;
	list($staxon, $sgff) = explode("\t" , $sln);
	$staxon = trim($staxon);
	$hout = fopen($staxon.".id2genesymbol.map.txt" , 'w');
	fnprocess($hout, $sgff); 
}

// extract gene annotation info from gff
function fnprocess($hout, $sgff) {
	$hgff = popen("zcat -f $sgff", 'r');
	$arrgenes = array(); 
	$arrrna2genemap  = array();
	$arrprotein2rnamap = array();
	
	while( false !== ($sln = fgets($hgff ) ) ) {
		if (strpos($sln, '#') === 0) continue;
		$sln = trim($sln);
		if ($sln == '') continue;
		$arrf = explode("\t" , $sln);
		if (count($arrf) != 9) continue;
		
		// map mrna to parent gene
		if ($arrf[2] == 'mRNA') {
			$arrannot = fnparsefields($arrf[8]);
			if (array_key_exists("ID" , $arrannot) && array_key_exists("Parent" , $arrannot)) {
				$arrrna2genemap[$arrannot['ID']] = $arrannot['Parent'];
			}
			continue;
		}

		// map cds/protein to mrna
		if ($arrf[2] == 'CDS') {
			$arrannot = fnparsefields($arrf[8]);
			if (array_key_exists("protein_id" , $arrannot) && array_key_exists("Parent" , $arrannot)) {
				$arrprotein2rnamap[$arrannot['protein_id']] = $arrannot['Parent'];
			}
			continue;
		}

		// capture gene metadata
		if ($arrf[2] == 'gene') {
			$arrannot = fnparsefields($arrf[8]);
			if (!array_key_exists("ID" , $arrannot)) continue;
			$arrgenes[$arrannot['ID']] = array('unknown','unknown');
			if (array_key_exists("Name" , $arrannot)) $arrgenes[$arrannot['ID']][0] = $arrannot['Name'];
			if (array_key_exists("description" , $arrannot)) $arrgenes[$arrannot['ID']][1] = $arrannot['description'];
		} 
	}

	// map protein identifiers to gene symbols
	foreach($arrprotein2rnamap as $sproteinid => $stranscriptid) {
		if (!array_key_exists($stranscriptid , $arrrna2genemap)) continue;
		$sgeneid = $arrrna2genemap[$stranscriptid];
		if (!array_key_exists($sgeneid , $arrgenes)) continue;
		fwrite($hout , $sproteinid . "\t" . $arrgenes[$sgeneid][0] . "\t" . $arrgenes[$sgeneid][1] . "\n");
	}
}

// split gff attribute fields
function fnparsefields($s) {
	$arrf1 = explode(";" , $s);
	$arrret = array();
	foreach($arrf1 as $sf) {
		$arrf2 = explode("=" , $sf);
		if (count($arrf2) == 2) $arrret[trim($arrf2[0])] = trim($arrf2[1]);
	}
	return $arrret;
}
?>