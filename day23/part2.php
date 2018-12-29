<?php
$file = fopen("in.txt", "r");
$bots = [];
while ($line = fscanf($file, "pos=<%d,%d,%d>, r=%d")) {
    $bots[] = $line;
}

$queue = new SPLPriorityQueue();
$queue->setExtractFlags(SplPriorityQueue::EXTR_PRIORITY);

for ($i = 0; $i < count($bots); $i++) {
    list($x, $y, $z, $r) = $bots[$i];
    $dist = abs($x) + abs($y) + abs($z);
    $queue->insert('Q', array(-max(0, $dist - $r), -1));
    $queue->insert('Q', array(-($dist + $r + 1), 1));
}

$ct = 0;
$mct = 0;
$res = 0;
foreach ($queue as $bot) {
    list($dist, $ch) = $bot;
    $ct -= $ch;
    if ($ct > $mct) {
        $res = -$dist;
        $mct = $ct;
    }
}

echo $res, "\n";
?>
