<?php
// convert input phylip file into mcmctree partition format
// codon positions 1, 2, and 3 are output in separate sequential blocks

$sIn = "/data2/projects/dyao/compare/mcmctree/hyphy/05_raxml/phylipformat/full.phy";
$sOut = "for_mcmctree.phy";

$h = fopen($sIn, 'r');
$hOut = fopen($sOut, 'w');

$nLn = 0;
$nLen = -1;
$arrPartitions = array();

// read input sequence data
while(false !== ($sLn = fgets($h))) {
    $nLn++;
    if ($nLn == 1) continue; // skip header line
    $sLn = trim($sLn);
    if ($sLn == '') continue;

    $arrRet = array("", "", "");
    // split taxon name and sequence
    list($sTaxon, $sSeq) = preg_split('/\s+/', $sLn);
    
    if ($nLen == -1) {
        $nLen = strlen($sSeq);
        if ($nLen % 3 != 0) {
            die("error: input sequence length not a multiple of 3\n");
        }
    }

    if ($nLen != strlen($sSeq)) {
        die("taxon $sTaxon has an abnormal sequence length\n");
    }

    // group nucleotides by codon position
    for($nPos = 0; $nPos < $nLen; $nPos++) {
        $arrRet[$nPos % 3] .= $sSeq[$nPos];
    }

    $arrPartitions[$sTaxon] = $arrRet;
}

// write data to output file in blocks
$nTaxonCount = count($arrPartitions);
$nPerPartitionLen = $nLen / 3;

for($nCodonPos = 0; $nCodonPos < 3; $nCodonPos++) {
    fwrite($hOut, " $nTaxonCount $nPerPartitionLen\n");
    foreach($arrPartitions as $sTaxon => $arrSeqs) {
        fwrite($hOut, "$sTaxon     ");
        fwrite($hOut, $arrSeqs[$nCodonPos] . "\n");
    }
    fwrite($hOut, "\n"); // separate partitions with a newline
}

fclose($h);
fclose($hOut);
?>