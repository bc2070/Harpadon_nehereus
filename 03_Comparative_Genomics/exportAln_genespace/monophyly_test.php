<?php
require_once(dirname(__FILE__) . "/lib.php");

/*
perform monophyly constraints testing
branch marking styles:
hyphy relax: use {T} for target nodes/branches, {R} for reference
codeml style: use #1 for target branches
*/

// default configuration settings
$sMonoDesc = "monophyly_desc.txt";
$sPremadeFasta = "ret_improved_cleanDNA.fasta";
$sOutDIR = "genetrees_improved";
$nThisPart = 0;
$nTotalPart = 1;

// parse command line arguments for parallel processing
while(count($argv) > 0) {
    $arg = array_shift($argv);
    switch($arg) {
        case '-m': $sMonoDesc = trim(array_shift($argv)); break;
        case '-p': $sPremadeFasta = trim(array_shift($argv)); break;
        case '-o': $sOutDIR  = trim(array_shift($argv)); break;
        case '-N': $nTotalPart  = trim(array_shift($argv)); break;
        case '-f': $nThisPart  = trim(array_shift($argv)); break;
    }
}

exec("mkdir -p $sOutDIR");
$hPremadeFasta = fopen($sPremadeFasta , "r");
$sSeqName = "";
$sSeq = "";
$arrFullCodingSeq = array();
$sCurrentGene = "";
$nGeneCount = -1;

// load previously computed results to enable resuming
$sOutFile = "$sOutDIR/ret_part$nThisPart.of.$nTotalPart.txt";
$arrComputedResults = fnLoadCurrentRet($sOutFile);
$hOut = fopen($sOutFile , 'a');

// read fasta stream and process individual genes
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
fnProcessAln($sCurrentGene, $arrFullCodingSeq);

// parse fasta headers and cluster sequences by gene
function fnProcessRecord($sSeqName, $sSeq) {
	global $arrFullCodingSeq , $sCurrentGene;
	if (strpos($sSeqName , "direction") !== false) return;
	preg_match("/Ortho:(\S+);Sp:(\S+);MappedToRef:(\S+);SpGeneId:(\S+);GroupId:(\S+)/", $sSeqName, $arrParsed);
	if (count($arrParsed) != 6) return;

	$sGeneName = $arrParsed[5];
	$sSpecies = $arrParsed[2];

	if ($sCurrentGene == $sGeneName) {
		if (!array_key_exists($sSpecies, $arrFullCodingSeq)) $arrFullCodingSeq[$sSpecies] = "";
		$arrFullCodingSeq[$sSpecies] .= $sSeq;
	} else {
		if (count($arrFullCodingSeq) > 0) fnProcessAln($sCurrentGene, $arrFullCodingSeq);
		$arrFullCodingSeq = array();
		$sCurrentGene = $sGeneName;
		$arrFullCodingSeq[$sSpecies] = $sSeq;
	}
}

// conduct monophyly constraint analysis
function fnProcessAln($sGeneName, $arrFullCodingSeq) {
	global $sOutDIR, $sMonoDesc, $nThisPart, $nTotalPart, $nGeneCount, $hOut, $arrComputedResults;

	$nGeneCount++;
	if ($nGeneCount % $nTotalPart != $nThisPart) return;

	if (array_key_exists($sGeneName , $arrComputedResults) && $arrComputedResults[$sGeneName][1] != 'AUFailed' && $arrComputedResults[$sGeneName][1] != 'TreeFailed') {
		echo("$sGeneName done skip\n");
		return;
	}

	$arrFullCodingSeq = fnExcludeLastStop($arrFullCodingSeq);
	$arrAlnRet = fnTranslateAlignment($arrFullCodingSeq, false);

    // check sequence diversity
	$bDiff = false;
	$sTempSeq = -1;
	foreach($arrFullCodingSeq as $sTaxon => $sSeq) {
		if ($sTempSeq == -1) $sTempSeq = $sSeq;
		if ($sTempSeq != $sSeq) { $bDiff = true; break; }
	}
	if (!$bDiff) {
		echo("$sGeneName all sequences identical\n");
		fwrite($hOut , "$sGeneName\tAllSeqIdentical\n");
		return;
	}
			
	$arrRemoveTaxa = array();
	foreach($arrFullCodingSeq as $sTaxon => $sSeq) {
		if (preg_replace("/[N\-n]/", "", $sSeq) == '') $arrRemoveTaxa[] = $sTaxon;
	}
	foreach($arrRemoveTaxa as $sRemoveTaxon) unset($arrFullCodingSeq[$sRemoveTaxon]);

    // run tree inference and AU test
	if (!$arrAlnRet["stopcodon"]) {
		$arrTaxa = array_keys($arrFullCodingSeq);
		$oConstraintTree = fnParseMonoDesc($sMonoDesc, array_flip($arrTaxa));
		$sConstraintTree = fnTree2Newick($oConstraintTree, array());
		
		$oRAxMLFree = new RAXML();
		$oRAxMLConstraint = new RAXML();
		$sAln = "";
		foreach($arrFullCodingSeq as $sTaxon => $sSeq) $sAln .= ">$sTaxon\n" . wordwrap($sSeq, 75, "\n", true) . "\n";

		$oRAxMLConstraint->SetAlignment($sAln);
		$oRAxMLFree->SetAlignment($sAln);
		$oRAxMLConstraint->SetConstraint($sConstraintTree.";");

		$oTreeConstraint = $oRAxMLConstraint->GetBestTree(true);
		$oTreeFree = $oRAxMLFree->GetBestTree(true);

		if ((!$oTreeConstraint['Success']) || (!$oTreeFree['Success'])) {
			fwrite($hOut , "$sGeneName\tTreeFailed\n");
			return;
		}

		$oRAxMLConstraint->RemoveTemp();
		$oRAxMLFree->RemoveTemp();

		$oAU = new AUTest();
		$oAU->SetAlignment($sAln);
		$oAU->SetTrees(array(trim($oTreeFree['Tree']), trim($oTreeConstraint['Tree'])));
		$oAURet = $oAU->DoTest();

		if ($oAURet === false) {
			fwrite($hOut , "$sGeneName\tAUFailed\n");
			return;
		}

		$oAU->RemoveTemp();
		$arrAURet = preg_split("/\s+/", $oAURet[1]);
		$sConstraintAccepted = (abs($arrAURet[0]) == 0 || $arrAURet[1] > 0.05) ? "accepted_monophyly" : "rejected_monophyly";
		fwrite($hOut , "$sGeneName\t".count($arrTaxa)."\t$sConstraintAccepted\t".$arrAURet[0]."\t".$arrAURet[1]."\t".trim($oTreeFree['Tree'])."\t".trim($oTreeConstraint['Tree'])."\n");
	} else {
		fwrite($hOut , "$sGeneName\tStopFound\n");
	}
}

// map input monophyly definitions to internal tree structure
function fnParseMonoDesc($sIn, $arrIncludeTaxon = true) {
	$hIn = fopen($sIn, 'r');
	$arrMap = array();
	while( false !== ($sLn = fgets($hIn) ) ) {
		$sLn = trim($sLn);
		$arrF = explode("\t" , $sLn);
		if (count($arrF) !=2) continue;
		$arrMap[$arrF[0]] = explode(",", $arrF[1]);
	}
	return fnBuildTree('root', $arrMap , $arrIncludeTaxon);
}

// recursive tree construction
function fnBuildTree($sNodeName, &$arrMap, &$arrIncludeTaxon) {
	$arrTree = array();
	if (!array_key_exists($sNodeName , $arrMap)) die("Node $sNodeName undefined\n");
	foreach($arrMap[$sNodeName] as $sChild) {
		$sChild = trim($sChild);
		if ($sChild[0] == '*') {
			$sChildNodeName = substr($sChild, 1);
			$oChildNode = fnBuildTree($sChildNodeName , $arrMap , $arrIncludeTaxon);
			if (count($oChildNode) > 0) $arrTree[$sChildNodeName] = $oChildNode;
		} else {
			if ($arrIncludeTaxon === true || array_key_exists($sChild, $arrIncludeTaxon)) $arrTree[$sChild] = true;
		}
	}
	return $arrTree;
}

// serialize tree structure into newick format with branch markings
function fnTree2Newick(&$oNode , $arrMarkBranches, $nStyle = 0, $bMark=false, $sMark="") {
    // recursively build newick string
    // ...
}

// load previously computed output file
function fnLoadCurrentRet($sOutFile) {
	if (!file_exists($sOutFile )) return array();
	$hPrevOut = fopen($sOutFile , 'r');
	$arrRet = array();
	while( false !== ($sLn = fgets($hPrevOut) ) ) {
		$sLn = trim($sLn);
		if ($sLn == '') continue;
		$arrF = explode("\t", $sLn);
		$arrRet[$arrF[0]] = $arrF;
	}
	fclose($hPrevOut);
    // rewrite file excluding failed jobs
	$hOut = fopen($sOutFile , 'w');
	foreach($arrRet as $sGroup => $arrLn) {
		if ($arrLn[1] != 'AUFailed' && $arrLn[1] != 'TreeFailed' ) fwrite($hOut , implode("\t" , $arrLn) . "\n");
	}
	fclose($hOut);
	return $arrRet;
}
?>