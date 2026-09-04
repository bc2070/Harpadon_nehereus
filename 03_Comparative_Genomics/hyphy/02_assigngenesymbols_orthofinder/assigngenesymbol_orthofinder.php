<?php
// input and output paths
$sorthogroups = "/data/projects/dyao/data/harpadon_nehereus/synteny/genespace/rundir/orthofinder/results_feb09/phylogenetic_hierarchical_orthogroups/n0.tsv";
$sout = "orthofinder_genesymbols.tsv";

// load gene symbol and description maps
$arrgenesymbolmap = glob("*.id2genesymbol.map.txt");
$arrunknownkeyword = array("/unknown/");
$arrgenesymbolmaps = array();
$arrgenedescriptionmaps = array();
$hout = fopen($sout , "w");

foreach($arrgenesymbolmap as $smap) {
	$arrm = explode('.', $smap);
	$ssp = $arrm[0];
	list( $arrgenesymbolmaps[$ssp] , $arrgenedescriptionmaps[$ssp]) = fnparsemap( $smap ); 
}

// process orthogroups
$horthogroups = fopen($sorthogroups , 'r');
$arrspcol = array();
$arrrefspp = array();

while( false !== ($sln = fgets($horthogroups) )) {
	$sln = trim($sln, "\n\r ");
	if ($sln == '') continue;
	$arrf = explode("\t"  , $sln);
	
	// handle header line
	if ($arrf[0] == 'hog') {
		$arrspcol = array_slice(array_flip($arrf) , 3 );
		$arrgenesymbolmaps = array_intersect_key($arrgenesymbolmaps, $arrspcol );
		$arrgenedescriptionmaps = array_intersect_key($arrgenedescriptionmaps, $arrspcol );
		$arrrefspp = array_keys($arrgenesymbolmaps);
		fwrite($hout, implode("\t", array_slice($arrf, 0, 3) )."\tgenesymbol\tdescription\t" );
		fwrite($hout , implode("\t", array_slice($arrf, 3))."\tallgenesymbols\talldescriptions\n" );
		continue;
	}
	
	// extract gene symbols and descriptions
	$sgroupid = $arrf[0];
	$arrsymbols = array();
	$arrdescriptions = array();
	$arrdescriptions['unknown'] = "unknown";
	
	foreach($arrrefspp as $ssp ) {
		$arrids = explode(",", $arrf[$arrspcol[$ssp]] );
		foreach($arrids as $sid) {
			$sid = trim($sid);
			list($sid) = explode('.', $sid);
			if (!array_key_exists($sid , $arrgenesymbolmaps[$ssp]) ) continue;

			$ssymbol = $arrgenesymbolmaps[$ssp][$sid];			
			$ssymbol = trim(preg_replace("/\(\d+ of .+/", "", $ssymbol));
			$sdes = $arrgenedescriptionmaps[$ssp][$sid];

			foreach($arrunknownkeyword as $sunknownkeyword) {
				if (preg_match($sunknownkeyword , $ssymbol) ===1 ) continue 2;
			}
			$ssymbol = strtolower($ssymbol);
			if (!array_key_exists($ssymbol , $arrsymbols)) $arrsymbols[$ssymbol] = 0;
			$arrsymbols[$ssymbol] += 1;
				
			if (!array_key_exists($ssymbol,  $arrdescriptions)) $arrdescriptions[$ssymbol] = $sdes;
			$arrdescriptions[$ssymbol] = (strlen($arrdescriptions[$ssymbol]) < strlen($sdes) && strlen($arrdescriptions[$ssymbol]) > 10 )? $arrdescriptions[$ssymbol] : $sdes;
		}
	}
	
	// finalize best gene symbol
	arsort( $arrsymbols , sort_numeric);
	$arrsymbolsflip = array_keys($arrsymbols);
	$sfinalsymbol = 'unknown';
	if (count($arrsymbolsflip) > 0) {
		foreach($arrsymbolsflip as $ssym) {
			if (strpos($ssym, ':')!==false) continue;
			if (substr($ssym, 0,3) == 'loc') continue;
			$sfinalsymbol = $ssym; 
		}
		if ($sfinalsymbol == 'unknown') $sfinalsymbol = $arrsymbolsflip[0];
	}

	// write output
	fwrite($hout, implode("\t", array_slice($arrf, 0, 3) )."\t".$sfinalsymbol."\t".$arrdescriptions[$sfinalsymbol]."\t" );
	fwrite($hout , implode("\t", array_slice($arrf, 3))."\t".implode('|', $arrsymbolsflip)."\t".implode('|', array_unique(array_slice($arrdescriptions,1) ))."\n" );
}

// helper function to parse mapping files
function fnparsemap( $smap ) {
	$hmap = fopen($smap, 'r');
	$arrret = array(array(), array());
	while( false !== ($sln = fgets($hmap) )) {
		$sln = trim($sln);
		if ($sln == '') continue;
		$arrf = explode("\t" , $sln);
		$arrret[0][$arrf[0]] = $arrf[1];
		$arrret[1][$arrf[0]] = preg_replace("/%2c transcript variant.*/" , '', $arrf[2]);
	}
	return $arrret;
}
?>