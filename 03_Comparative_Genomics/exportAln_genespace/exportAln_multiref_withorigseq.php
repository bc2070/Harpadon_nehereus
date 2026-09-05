<?php
// increase memory limit for large datasets
ini_set('memory_limit', -1);

require_once(dirname(__FILE__) . "/lib.php");

// configuration file paths
$sRefDef = "refs.txt";
$sOrthologList = "genespace.orthogroups.txt";
$sOutgroupList = "outgroups.txt";
$sGenomeDef = "genomes.txt";

// default execution parameters
$arrGenomes = array();
$sOutputPrefix = "output/ret";
$nTotalParts = 1;
$nThisPart = 0;
$nMissingCutoff = 0.5;
$sMissingFileRules = "missingrules_relax.txt";
$bMaskSeqWStop = true;
$bOnlyCreateFastaIndex  = false;
$nCovBlackListPCutoff = 0.01;

// ensure output directory exists
exec("mkdir -p output");

// parse command line arguments
while(count($argv) > 0) {
    $arg = array_shift($argv);
    switch($arg) {
    case '-r': $sRefDef = trim(array_shift($argv)); break;
    case '-R': $sGenomeDef = trim(array_shift($argv)); break;
	case '-O': $sOrthologList  = trim(array_shift($argv)); break;
	case '-o': $sOutputPrefix  = trim(array_shift($argv)); break;
	case '-N': $nTotalParts  = trim(array_shift($argv)); break;
	case '-f': $nThisPart  = trim(array_shift($argv)); break;
	case '-m': $bMaskSeqWStop  = !(trim(array_shift($argv))=="no"); break;
	case '-I': $bOnlyCreateFastaIndex  = true; break;
	case '-C': $nCovBlackListPCutoff = floatval(trim(array_shift($argv))); break;
    }
}

/* load outgroup sequences */
$hOutGroupList = fopen($sOutgroupList, 'r');
$arrOutgroupProt = array();
while(false !== ($sLn = fgets($hOutGroupList) ) ) {
    $sLn = trim($sLn);
    if ($sLn == '' || $sLn[0] == '#') continue;
    list($sTaxon, $sFile) = explode("\t" , $sLn);
    echo("loading CDS file for $sTaxon...\n");
    $arrFasta = fnParseProtFasta($sFile);
    $arrOutgroupProt[$sTaxon] = $arrFasta;
}

/* parse reference genome definitions */
$hRefDef = fopen($sRefDef , "r");
$arrRefGTFs = array();
$nLn = -1;
echo("Parsing reference genome definitions...\n");
while( ($sLn=fgets($hRefDef))!==false ) {
	$sLn = trim($sLn);
	if ($sLn == "") continue;
	$nLn++;
	if ($nLn==0) continue; 
	$arrFields = explode("\t", $sLn);
	$arrRefGTFs[$arrFields[0]] = $arrFields[2];
}

/* initialize output file handles */
$sOutputPrefix = $sOutputPrefix."_par".$nThisPart."_of_".$nTotalParts;
$hOutAA = fopen($sOutputPrefix."_AA.fasta" , "w");
$hCleanOutAA = fopen($sOutputPrefix."_cleanAA.fasta" , "w");
$hOutDNA = fopen($sOutputPrefix."_DNA.fasta" , "w");
$hCleanOutDNA = fopen($sOutputPrefix."_cleanDNA.fasta" , "w");

/* parse internal genome mapping definitions */
$arrRefGenomes = array();
$arrRefFastaHack = array();
$nLn=-1;
$arrGTFs = array();
$arrPseudoGenomes = array();
$arrSp2Ref = array();
$arrSp2Genome = array();
$arrSpCovBlackList = array();

echo("Parsing genome definitions...\n");
while( ($sLn=fgets($hGenomeDef))!==false ) {
	$sLn = trim($sLn);
	if ($sLn == "") continue;
	$nLn++;
	if ($nLn==0) continue;
	
	list($sRef, $sSp, $sPseudoGenomeFa, $sCovBlkList ) = explode("\t", $sLn);
	if (!array_key_exists($sRef, $arrRefGTFs)) die("Reference $sRef not found in reference definition file $sRefDef\n");
	if (!array_key_exists( $sRef , $arrPseudoGenomes) ) $arrPseudoGenomes[$sRef] = array();

	$arrPseudoGenomes[$sRef][] = $sPseudoGenomeFa;
	$arrSp2Ref[$sSp] =  $sRef;
	$arrSp2Genome[$sSp] =  $sPseudoGenomeFa;
	$arrSpCovBlackList[$sSp] = fnParseBlackList($sCovBlkList);
}

/* load gff annotations for all reference genomes */
foreach($arrPseudoGenomes as $sRef => $arrPseudoGenomesForRef) {
	$arrGTFs[$sRef] = new MappedCDSGFF();
	$arrGTFs[$sRef]->LoadGFF($arrRefGTFs[$sRef] , $arrPseudoGenomesForRef , 'CDS' );
}
echo("Parsed in ".count($arrGTFs)." genome definitions\n");

if ($bOnlyCreateFastaIndex) die();

/* load ortholog group definitions */
$arrOrthologSpp = array();
$arrOrthologs = array();
$arrOrthologMeta = array();
$nLn = -1;
echo("Parsing ortholog definitions $sOrthologList ...\n");
$hOrthologList = fopen($sOrthologList , "r");
while( ($sLn=fgets($hOrthologList))!==false ) {
	$sLn = trim($sLn);
	if ($sLn == "") continue;
	$nLn++;
	if ($nLn==0) {
		$arrOrthologSpp = array_flip(array_slice( explode("\t" , $sLn) , 3));
		continue;
	}
	$arrFields = explode("\t", $sLn);
	$arrOrthologs[] =  array_slice($arrFields , 3);
	$arrOrthologMeta[] = array_slice($arrFields , 0, 3);
}
echo("Loaded ". count($arrOrthologs) ." ortholog definitions\n" );

/* process missing data rules */
$arrMissingRules = array();
if ($sMissingFileRules!="") {
	$hMsF = fopen($sMissingFileRules , "r");
	if (!$hMsF) die("Cannot open Missing rule file\n");
	fgets($hMsF);
	while( false !== ($sLn = fgets($hMsF))) {
		$sLn = trim($sLn);
		if ($sLn =="") continue;
		list($nRatio, $sTaxa) = explode("\t" , $sLn); 
		$arrTaxa = explode("," , $sTaxa);
		$arrMissingRules[] = array('Ratio' => $nRatio , 'Taxa' => $arrTaxa );
	}
} else {
	foreach($arrRefGenomes as $sTaxonName => $sTaxonFile) {
		$arrMissingRules[] = array('Ratio' => $nMissingCutoff , 'Taxa' => array($sTaxonName) );
	}
}

/* main loop to extract and align sequences */
$arrRefGenomeSpp = array_keys($arrRefGTFs);
for($nOrth=0;$nOrth<count($arrOrthologs);$nOrth++ ) {
    // skip indices handled by other parallel processes
	if ($nOrth % $nTotalParts != $nThisPart) continue;

	$arrOrthMeta = $arrOrthologMeta[$nOrth];
	$arrSpGeneIDs = array(); 
    
    foreach($arrRefGenomeSpp as $sRefGenomeSp) {
        if (!array_key_exists($sRefGenomeSp , $arrOrthologSpp) ) {
            echo("Warning: reference species $sRefGenomeSp not found in ortholog definition skipping gene\n");
	    continue 2;
        }
        $arrSpGeneIDs[$sRefGenomeSp] = $arrOrthologs[$nOrth][$arrOrthologSpp[$sRefGenomeSp]];
    }
    
	echo("Gene: ");
    // validate gene existence in gff
	foreach($arrSpGeneIDs as $sRef => $sIDString ) {
	    list($s1, $sSpGeneID, $s3) = explode('|', $sIDString);
		if (  $arrGTFs[$sRef]->fnSpGeneId2RNAID($sSpGeneID) === false) {
			echo("The gene name $sSpGeneID is not found in the GFF file for reference genome $sRef skipping gene\n");
			continue 2;
		}
		echo("  $sRef:$sSpGeneID ");
	}
	echo("\n");

	$arrFullCodingSeq = array();
	$bAllSppHaveGeneSeq = true;
	foreach($arrSp2Ref as $sSpecies => $sRefForSp) {
        // filter sequences based on coverage blacklist
		if ( array_key_exists( $arrSpGeneIDs[$sRefForSp], $arrSpCovBlackList[$sSpecies])) {
			echo("Notice: $sSpecies coverage too high for gene ".$arrSpGeneIDs[$sRefForSp]." excluding\n");
			continue;
		}

		$oGTF = $arrGTFs[$sRefForSp];
		list($sTmp, $sSpGeneID , $sTmp2) =  explode('|', $arrSpGeneIDs[$sRefForSp]);
		$sRNAID = $oGTF->fnSpGeneId2RNAID($sSpGeneID);
		echo("$sSpecies / $sRefForSp / $sRNAID / " . $sSpGeneID ."\n");
		$omRNA = $oGTF->GetmRNA('maker' , $sRNAID);
		$oExtracted = $oGTF->ExtractmRNASequence('maker' , $sRNAID, $arrSp2Genome[$sSpecies]);
		$sTrimAA = $oExtracted['AA'];
		$sTrimDNA = $oExtracted['mRNA'];

		// mask annotated large insertions with placeholders
		if (array_key_exists('hugeinsertionlist', $omRNA['annot'])) {
			$arrHugeInsList = explode(",", $omRNA['annot']['hugeinsertionlist']);
			foreach($arrHugeInsList as $sHugeGap) {
				$sHugeGap = trim($sHugeGap);
				if ($sHugeGap == "") continue;
				list($nGapStart, $nGapEnd) = explode('-', $sHugeGap);
				$nGapLen = abs($nGapEnd-$nGapStart) + 1;
				$nDNAGapLen = $nGapLen * 3;
				$sTrimAA = substr_replace($sTrimAA , str_repeat('X', $nGapLen) , ($nGapStart-1) ,  $nGapLen);
				$sTrimDNA = substr_replace($sTrimDNA , str_repeat('N', $nDNAGapLen) , ($nGapStart-1)*3 ,  $nDNAGapLen);
			}
		}

		$n5PrimeUncertain = 0;
		$n3PrimeUncertain = 0;
		if (array_key_exists('5primeuncertain', $omRNA['annot'])) $n5PrimeUncertain = intval($omRNA['annot']['5primeuncertain']);
		if (array_key_exists('3primeuncertain', $omRNA['annot'])) $n3PrimeUncertain = intval($omRNA['annot']['3primeuncertain']);

		// apply terminal trimming
		$sTrimAA = substr($sTrimAA , $n5PrimeUncertain , strlen($sTrimAA) - $n5PrimeUncertain - $n3PrimeUncertain );
		$sTrimDNA = substr($sTrimDNA , $n5PrimeUncertain * 3 , strlen($sTrimDNA) - ($n5PrimeUncertain*3) - ($n3PrimeUncertain*3) );
		$arrFullCodingSeq[$sSpecies] = $sTrimDNA;
	}

    // handle sequence translation and stop codon removal
	$arrFullCodingSeq = fnExcludeLastStop($arrFullCodingSeq);
	$arrAlnRet = fnTranslateAlignment($arrFullCodingSeq , false);

	if ( $arrAlnRet["stopcodon"]  && $bMaskSeqWStop) {
		foreach( $arrAlnRet["stoptaxa"] as $sTaxonWStop) {
			$arrFullCodingSeq[$sTaxonWStop] = str_repeat("N", strlen($arrFullCodingSeq[$sTaxonWStop]));
		}
		$arrAlnRet["stopcodon"] = false;
	}

    // calculate missing data ratio
	$arrNonNRatio = array();
	foreach($arrFullCodingSeq  as $sTaxon => $sSeq) {
		$arrNonNRatio[$sTaxon] = 1-substr_count($sSeq , "N") / strlen($sSeq) ;
	}

    // incorporate outgroup sequences
	foreach( array_keys($arrOutgroupProt) as $sOutgroupSp ) {
		if (!array_key_exists($sOutgroupSp, $arrOrthologSpp) ) die("Outgroup species $sOutgroupSp not defined\n");
		$sIDString = $arrOrthologs[$nOrth][$arrOrthologSpp[$sOutgroupSp]];
		if ($sIDString == 'NA') continue;
		list($s1, $s2, $sGeneEnsNCBIID) = explode('|', $sIDString);
		if (!array_key_exists($sGeneEnsNCBIID ,$arrOutgroupProt[$sOutgroupSp] ) ) continue;
        
		$sSeq2Add = $arrOutgroupProt[$sOutgroupSp][$sGeneEnsNCBIID];
		$sLastCodon = substr($sSeq2Add , -3);
		if (in_array($sLastCodon, ["TGA", "TAG", "TAA", "TAR"])) $sSeq2Add = substr($sSeq2Add, 0, strlen($sSeq2Add) -3 );
	    $arrFullCodingSeq[$sOutgroupSp] = $sSeq2Add;
	}

    // final export of aligned sequences
	$arrFullCodingSeq2 = array();
	foreach($arrFullCodingSeq as $sTaxon => $sSeq) {
		if (array_key_exists($sTaxon , $arrNonNRatio) && $arrNonNRatio[$sTaxon] < $nMissingCutoff) continue;
		$sRefForSp = array_key_exists($sTaxon,  $arrSp2Ref)? $arrSp2Ref[$sTaxon] : $sTaxon;
		$sSpGeneId = ($sRefForSp ==  $sTaxon)? "000000" : (explode('|', $arrSpGeneIDs[$sRefForSp]))[1];
		$sSeqID = "Ortho:$nOrth;Sp:$sTaxon;MappedToRef:$sRefForSp;SpGeneId:$sSpGeneId;GroupId:".$arrOrthMeta[0];
		$arrFullCodingSeq2[$sSeqID] = $sSeq;
	}

	$arrTrX = fnTranslatorX($arrFullCodingSeq2);
	if (false !== $arrTrX) {
		fwrite($hOutDNA , $arrTrX[0]);
		fwrite($hCleanOutDNA , $arrTrX[1]);
		fwrite($hOutAA , $arrTrX[2]);
		fwrite($hCleanOutAA , $arrTrX[3]);
	} else {
		echo("TranslatorX failed on gene \n");
	}
}

// utility function to filter blacklist
function fnParseBlackList($sCovBlkList) {
	global $nCovBlackListPCutoff;
	if (!file_exists($sCovBlkList)) return array();
	$hCovBlkList = fopen($sCovBlkList , 'r');
	$arrRet = array();
	while(false !== ($sLn = fgets($hCovBlkList) ) ) {
		$sLn = trim($sLn);
		$arrF = explode("\t" , $sLn);
		if (count($arrF) <9 ) continue;
		if ($arrF[8] < $nCovBlackListPCutoff) $arrRet[$arrF[0]] = true;
	}
	return $arrRet;
}

// utility function to parse fasta files
function fnParseProtFasta($sFile) {
    $hIn = fopen($sFile, 'r');
    $sSeq = ""; $sSeqName = ""; $arrRet = array();
    do {
        $sLn = fgets($hIn);
        if (false === $sLn || $sLn[0] == ">") {
            if ($sSeq != '') $arrRet[$sSeqName] = $sSeq;
            if (false === $sLn) break;
            $sSeqName = substr(trim($sLn), 1);
            $sEnsID = str_replace([".", ":", "|"], "_", explode(" ", $sSeqName)[0]);
            $sSeqName = $sEnsID; $sSeq = ""; continue;
        }
        $sSeq .= trim($sLn);
    } while(true);
    return $arrRet;
}
?>