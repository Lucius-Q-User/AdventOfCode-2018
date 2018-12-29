<?php
$file = fopen("in.txt", "r");
$bots = [];
while ($line = fscanf($file, "pos=<%d,%d,%d>, r=%d")) {
    $bots[] = $line;
}

$maxrange = 0;
$mri = 0;

for ($i = 0; $i < count($bots); $i++) {
    list($x, $y, $z, $r) = $bots[$i];
    if ($r > $maxrange) {
        $maxrange = $r;
        $mri = $i;
    }
}

list($ox, $oy, $oz, $r) = $bots[$mri];

$in_range = 0;

for ($i = 0; $i < count($bots); $i++) {
    list($x, $y, $z, $_r) = $bots[$i];
    if (abs($x - $ox) + abs($y - $oy) + abs($z - $oz) < $r) {
        $in_range++;
    }
}

echo $in_range, "\n";
?>
