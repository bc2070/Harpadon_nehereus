<?php
// filtering thresholds for blastp alignments
$nMinBlastPIdentity = 50; 
$nMaxBlastPIdentityDiff = 20; 
$nTreatAsBigGap = 2; 
$nTreatAsHugeGap = 10; 

// execute shell command with optional return capturing
function fnExec($sCmd, &$arrRet = false, &$retVal=false) {
	echo("\t\t\t > ".$sCmd.PHP_EOL);
	if ($arrRet !== false) {
		if ($retVal===false) exec($sCmd , $arrRet);
		else exec($sCmd , $arrRet, $retVal);
	} else {
		exec($sCmd);
	}
}

// evaluate predicted protein model against evidence using blastp
function fnScoreExonerateModel($sPredictedProt , $sEvidenceProt , $sDIR, $bIgnoreInternalStop = false ) {
	global $nMinBlastPIdentity , $nMaxBlastPIdentityDiff , $nTreatAsBigGap , $nTreatAsHugeGap; 

	$arrScores = array('score' => 0, 'internalstop' => false);

    // strip terminal stop codons
	if (substr($sPredictedProt , -1,1) == '*' ) $sPredictedProt = substr($sPredictedProt , 0, strlen($sPredictedProt)-1 );
	if (substr($sEvidenceProt , -1,1) == '*' ) $sEvidenceProt = substr($sEvidenceProt , 0, strlen($sEvidenceProt)-1 );

    // handle internal stop codons
	if ($bIgnoreInternalStop) {
		$sPredictedProt = str_replace('*' , 'X', $sPredictedProt);
		if (strpos($sPredictedProt, '*') !== false ) $arrScores['internalstop'] = true;
	}
	if (strpos($sPredictedProt, '*') !== false ) {
		$arrScores['internalstop'] = true;
		return $arrScores;
	}

	$nPredLen = strlen($sPredictedProt);
	$nEvidLen = strlen($sEvidenceProt);
	$sPredFa = "$sDIR/_predprot.fa";
	$sEvidFa = "$sDIR/_evidprot.fa";

	$hPredFa = fopen($sPredFa , "w");
	$hEvidFa = fopen($sEvidFa , "w");
	fwrite($hPredFa , ">pred\n$sPredictedProt");
	fwrite($hEvidFa , ">evid\n$sEvidenceProt");

    // run blastp to compare prediction against evidence
	$sBlastOut = "$sDIR/_scoremodel.blast.out";
	exec("makeblastdb -in $sPredFa -dbtype prot; blastp -task blastp -db $sPredFa -query $sEvidFa -evalue 1e-10 -out $sBlastOut -outfmt '7 qseqid sseqid qstart qend sstart send evalue bitscore length pident mismatch gapopen btop'");

 	// parse blast output
	$hBlastOut = fopen($sBlastOut, "r");
	$arrPredBlastRet = array(); 
	$arrEvidBlastRet = array(); 
	$arrPercIden = array();
	while(false !== ($sLn = fgets($hBlastOut) )) {
		$sLn = trim($sLn);
		if ($sLn == '' || $sLn[0] == '#') continue;
		$arrF = explode("\t" , $sLn);
		if (count($arrF) != 13 || $arrF[2] > $arrF[3] || $arrF[4] > $arrF[5]) continue;
		if ($arrF[9] < $nMinBlastPIdentity) continue;

		$arrPredBlastRet[$arrF[4]] = array('qstart' => $arrF[2], 'qend' =>$arrF[3], 'hstart' => $arrF[4], 'hend' => $arrF[5], 'percid' => $arrF[9], 'btop' => $arrF[12]);
		$arrEvidBlastRet[$arrF[2]] = array('qstart' => $arrF[2], 'qend' =>$arrF[3], 'hstart' => $arrF[4], 'hend' => $arrF[5], 'percid' => $arrF[9], 'btop' => $arrF[12]);
		$arrPercIden[] = $arrF[9];
	}

	if (count($arrPercIden) == 0 ) return $arrScores;

    // calculate alignment coverage and scores
	$nMinPercIden = max($arrPercIden) - $nMaxBlastPIdentityDiff;
	ksort($arrPredBlastRet);
	ksort($arrEvidBlastRet);

    // compute scores for prediction and evidence
    // (Logic for mapping BTOP strings to alignment scores and coverage)
	$arrPredScores = array_fill(1 , $nPredLen , 0);
	$arrPredCov = array_fill(1 , $nPredLen , 0);
    // ... processing logic loops ...

    // aggregate metrics
	$arrScores['score'] = array_sum($arrEvidScores) + array_sum($arrPredScores) + $oEvidCovScore['gappenalty'] + $oPredCovScore['gappenalty'];
	// ... fill completion stats ...

	return $arrScores;
}

// compute coverage gaps and sequence completeness
function fnCheckCov(&$arrEvidCov) {
	global $nTreatAsBigGap , $nTreatAsHugeGap; 
	$nFullLen = count($arrEvidCov);
	$sEvidCov = fnSmoothCov(implode('' , $arrEvidCov));

    // identify 5' and 3' missing regions
	preg_match("/^0+/", $sEvidCov, $arrM);
	$n5PrimeMiss = (count($arrM) > 0) ? strlen($arrM[0]) : 0;
	preg_match("/0+$/", $sEvidCov, $arrM);
	$n3PrimeMiss = (count($arrM) > 0) ? strlen($arrM[0]) : 0;

    // identify internal gaps and classify by size
	preg_match_all("/0+/", $sEvidCov, $arrM, PREG_OFFSET_CAPTURE);
    // ... logic to classify small/big/huge gaps ...

	return array( /* array of coverage metrics */ );
}

// smooth coverage data using sliding window
function fnSmoothCov($s) {
	$sRet = $s;
    // merge fragmented gaps
	preg_match_all('/-+0+-+/', $sRet, $arrM, PREG_OFFSET_CAPTURE);
	foreach($arrM[0] as $oMatch ) $sRet = substr_replace($sRet, str_repeat('0', strlen($oMatch[0])), $oMatch[1], strlen($oMatch[0]));

    // apply sliding window smoothing
	$nWinSize = 10;
    // ... smoothing loops ...
	return str_replace('-','0', $sRet);
}

// serialize associative array to GFF style attribute string
function fnArr2Annot($arr) {
	$s = "";
	foreach($arr as $sKey => $sVal) {
		if ($sVal === false) $sVal=0;
		$s .= "$sKey=$sVal;";
	}
	return substr($s, 0, strlen($s)-1);
}

// parse GFF style attribute string to associative array
function fnParseAnnotation($s) {
	$arrMap = array();
	$arrF = explode(';' , $s);
	foreach($arrF as $v) {
		$arrPair = explode('=' , $v);
		if (count($arrPair) !=2) continue;
		$arrMap[trim($arrPair[0])] = preg_replace('/^"|"$/', '', trim($arrPair[1]));
	}
	return $arrMap;
}
?>