<?php
// increase memory limit for large alignment processing
ini_set("memory_limit", "-1");

require_once(dirname(__FILE__) . "/lib.php");

/*
test for monophyly constraints present in monophyly_desc_txt
branch marking styles:
hyphy relax: target nodename{t} or (a{t},b{t}){t} reference {r} do not use {u}
codeml style: marks all child branches as foreground: $1 (not used) marks one branch as foreground: #1 
*/

$sPremadeFasta = "ret_improved_cleanDNA.fasta";
$sOutDIR = "./phylipformat";
$nMin4FoldPerc = 0.5; // threshold for 4-fold degenerate site inclusion

// parse command line arguments
while(count($argv) > 0) {
    $arg = array_shift($argv);
    switch($arg) {
        case '-p':
            $sPremadeFasta = trim(array_shift($argv));
            break;
        case '-o':
            $sOutDIR  = trim(array_shift($argv));
            break;
        case '-T':
            $sTreeFolder  = trim(array_shift($argv));
            break;
        case '-S':
            $sGeneSymbolMap  = trim(array_shift($argv));
            break;
    }
}

// ensure output directory exists
exec("mkdir -p $sOutDIR");

$hPremadeFasta = fopen($sPremadeFasta , "r");
$sSeqName = "";
$sSeq = "";
$arrFullCodingSeq = array();
$sCurrentGene = "";

// define output file handles
$sOutFileFull = "$sOutDIR/full.phy";
$sOutFile4Fold = "$sOutDIR/4fold.phy";
$sOutFileCodon12 = "$sOutDIR/codon12.phy";

$hOutFull = fopen($sOutFileFull , 'w');
$hOut4fold = fopen($sOutFile4Fold , 'w');
$hOutCodon12 = fopen($sOutFileCodon12 , 'w');

$arrProccessedAln = array();
$arrTaxaList = array();

// read fasta records
do {
	$sLn = fgets($hPremadeFasta);

	if ($sLn==false) {
		fnProcessRecord($sSeqName, $sSeq);
		break;
	}

	$sLn = trim($sLn);
	if (substr($sLn , 0,1) == ">") {
		fnProcessRecord($sSeqName, $sSeq);
		$sSeqName = substr($sLn , 1);
		$sSeq = "";
	} else {
		$sSeq .= $sLn;
	}

} while (true);
fnProcessAln($sCurrentGene,$arrFullCodingSeq);

// output gene counts per taxon
echo("genes for each taxon:\n");
foreach($arrTaxaList as $sTaxon => $nGeneCount) {
	echo("$sTaxon\t$nGeneCount\n");
}

// write phylip formatted files
fnWritePhylip($arrProccessedAln['cleancols'], $hOutFull);
fnWritePhylip($arrProccessedAln['pos12'], $hOutCodon12);
fnWritePhylip($arrProccessedAln['4fold'], $hOut4fold);

// parse fasta headers and aggregate sequences by gene
function fnProcessRecord($sSeqName, $sSeq) {
	global $arrFullCodingSeq , $sCurrentGene;
	if (strpos($sSeqName , "direction") !== false  ) {
		return; 
	}

	preg_match("/Ortho:(\S+);Sp:(\S+);MappedToRef:(\S+);SpGeneId:(\S+);GroupId:(\S+)/",  $sSeqName, $arrParsed);

	if (count($arrParsed)!=6 ) {
		return;
	}
	$sGeneName = $arrParsed[5];
	$sSpecies = $arrParsed[2];

	if ($sCurrentGene == $sGeneName ) {
		if (!array_key_exists($sSpecies , $arrFullCodingSeq)) {
			$arrFullCodingSeq[$sSpecies] = "";
		}
		$arrFullCodingSeq[$sSpecies] .= $sSeq;
	} else {
		if (count($arrFullCodingSeq) > 0) {
			fnProcessAln($sCurrentGene,$arrFullCodingSeq);
		}
		$arrFullCodingSeq = array();
		$sCurrentGene = $sGeneName;
		$arrFullCodingSeq[$sSpecies] = $sSeq;
	}
}

// partition alignments into full codon, pos12, and 4-fold degenerate
function fnProcessAln($sGeneName,$arrFullCodingSeq) {
	global $arrProccessedAln, $arrTaxaList, $nMin4FoldPerc;
	
	$arrTaxa = array_keys($arrFullCodingSeq);
	$nAlnLen = strlen($arrFullCodingSeq[$arrTaxa[0]]);

	if ($nAlnLen % 3 != 0) {
		die("error: gene $sGeneName not a multiplication of 3\n");
	}

	$arrRetCol = array();
	$arrRetPos12 = array();
	$arrRet4fold = array();

	foreach($arrTaxa as $sTaxon) {
		if (!array_key_exists($sTaxon , $arrTaxaList) ) {
			$arrTaxaList[$sTaxon] = 0;
		}
		$arrTaxaList[$sTaxon]++;
		if (strlen($arrFullCodingSeq[$sTaxon]) != $nAlnLen ) {
			die("error: gene $sGeneName unequal length at taxon $sTaxon\n");
		}
		$arrRetCol[$sTaxon] = '';
		$arrRetPos12[$sTaxon] = '';
		$arrRet4fold[$sTaxon] = '';
	}

	// process alignment by codon
	for($nPos=0;$nPos<$nAlnLen; $nPos+=3) {
		$arrCol = array();
		$arrPos12 = array();
		$arrLastPos = array();
		$n4foldTaxa = 0;
		
		foreach($arrFullCodingSeq as $sTaxon => $sSeq) {
			$sCodon = substr($sSeq, $nPos, 3);
			$bIs4Fold = fnIs4FoldDegen($sCodon);
			if ($bIs4Fold === -1) {
				continue 2; 
			}

			if ($bIs4Fold) {
				$n4foldTaxa++;
			}

			$arrCol[$sTaxon] = $sCodon;
			$arrPos12[$sTaxon] = substr($sCodon, 0,2);
			$arrLastPos[$sTaxon] = $sCodon[2];
		}

		foreach($arrTaxa as $sTaxon) {
			$arrRetCol[$sTaxon] .= $arrCol[$sTaxon];
			$arrRetPos12[$sTaxon] .= $arrPos12[$sTaxon];
			if ($n4foldTaxa/count($arrTaxa) >= $nMin4FoldPerc)  {
				$arrRet4fold[$sTaxon] .= $arrLastPos[$sTaxon];
			}
		}
	}

	$arrProccessedAln['cleancols'][$sGeneName] = $arrRetCol;
	$arrProccessedAln['pos12'][$sGeneName] = $arrRetPos12;
	$arrProccessedAln['4fold'][$sGeneName] = $arrRet4fold;
}

// utility to write phylip files
function fnWritePhylip($arrSeqs, $h) {
	global $arrTaxaList;
	$arrOutSeq = array();
	foreach($arrTaxaList as $sTaxon => $n) {
		$arrOutSeq[$sTaxon] = '';
	}

	$nTotalAlnLen = 0;
	foreach($arrSeqs as $sGeneName => $arrGeneSeqs) {
		list($sFirstKey) = array_keys($arrGeneSeqs);
		$nAlnLen = strlen($arrGeneSeqs[$sFirstKey]);

		foreach($arrTaxaList as $sTaxon => $n) {
			if (!array_key_exists($sTaxon , $arrGeneSeqs) ) {
				$arrOutSeq[$sTaxon] .= str_repeat('N', $nAlnLen);
				continue;
			}
			$arrOutSeq[$sTaxon] .=  $arrGeneSeqs[$sTaxon];
		}
		$nTotalAlnLen += $nAlnLen;
	}

	fwrite($h , " ".count($arrTaxaList)." $nTotalAlnLen\n");
	foreach($arrOutSeq as $sTaxon => $sSeq) {
		fwrite($h , "$sTaxon\t\t\t\t\t$sSeq\n");
	}
}
?>