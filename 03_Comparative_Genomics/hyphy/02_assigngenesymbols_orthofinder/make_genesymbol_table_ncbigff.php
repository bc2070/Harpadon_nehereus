<?php
// input file with taxon names and gff paths
$slist = "gffs1.txt";
$hlist = fopen($slist, 'r');

while( false !== ($sln = fgets($hlist) ) ) {
	$sln = trim($sln);
	if ($sln == '') continue;
	list($staxon, $sgff) = explode("\t" , $sln);
	$hout = fopen($staxon.".id2genesymbol.map.txt" , 'w');
	fnprocess($hout, $sgff); 
}

// extract gene symbols and product names from gff
function fnprocess($hout, $sgff) {
	$hgff = popen("zcat -f $sgff", 'r');

	while( false !== ($sln = fgets($hgff ) ) ) {
		if (strpos($sln, '#') === 0) continue;
		$sln = trim($sln);
		if ($sln == '') continue;

		$arrf = explode("\t" , $sln);
		if (count($arrf) != 9) continue;
		
		// parse mrna attributes for symbol and product
		if ($arrf[2] == 'mRNA') {
			$arrannot = fnparsefields($arrf[8]);
			if (!array_key_exists("ID" , $arrannot) ) continue;
			
			$sgenesymbol = array_key_exists("gene" , $arrannot) ? $arrannot['gene'] : 'unknown';
			$sgenefullname = array_key_exists("product" , $arrannot) ? $arrannot['product'] : 'unknown';
			list($sid) = explode('.', $arrannot['ID']);
			
			fwrite($hout , $sid . "\t" . $sgenesymbol . "\t" . $sgenefullname  . "\n"  );
			continue;
		}
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