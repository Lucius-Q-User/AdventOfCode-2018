use strict;
use warnings;
use v5.010;

use Data::Dumper qw(Dumper);

my $gridsize = 50;

open(my $fh, "<", "in.txt") or die "npf";
my @grid;
while (my $row = <$fh>) {
    chomp $row;
    my @spl = split(//, $row);
    push @grid, \@spl
}

sub countAround {
    my $x = $_[0];
    my $y = $_[1];
    my $sym = $_[2];
    my $accm = 0;
    if ($x > 0) {
        if ($y > 0) {
            if ($grid[$x - 1][$y - 1] eq $sym) {
                $accm++
            }
        }
        if ($grid[$x - 1][$y] eq $sym) {
            $accm++
        }
        if ($y < ($gridsize - 1)) {
            if ($grid[$x - 1][$y + 1] eq $sym) {
                $accm++
            }
        }
    }
    if ($y > 0) {
        if ($grid[$x][$y - 1] eq $sym) {
            $accm++
        }
    }
    if ($y < ($gridsize - 1)) {
        if ($grid[$x][$y + 1] eq $sym) {
            $accm++
        }
    }
    if ($x < ($gridsize - 1)) {
        if ($y > 0) {
            if ($grid[$x + 1][$y - 1] eq $sym) {
                $accm++
            }
        }
        if ($grid[$x + 1][$y] eq $sym) {
            $accm++
        }
        if ($y < ($gridsize - 1)) {
            if ($grid[$x + 1][$y + 1] eq $sym) {
                $accm++
            }
        }
    }
    return $accm
}

sub countRV {
    my $wood = 0;
    my $hashes = 0;
    for (my $x = 0; $x < $gridsize; $x++) {
        for (my $y = 0; $y < $gridsize; $y++) {
            if ($grid[$x][$y] eq "#") {
                $hashes++;
            }
            if ($grid[$x][$y] eq "|") {
                $wood++;
            }
        }
    }
    return $wood * $hashes
}

for (my $i = 0; $i < 10; $i++) {
    my @narr;
    for (my $x = 0; $x < $gridsize; $x++) {
        for (my $y = 0; $y < $gridsize; $y++) {
            if ($grid[$x][$y] eq ".") {
                if (countAround($x, $y, "|") >= 3) {
                    $narr[$x][$y] = "|";
                } else {
                    $narr[$x][$y] = ".";
                }
            } elsif ($grid[$x][$y] eq "|") {
                if (countAround($x, $y, "#") >= 3) {
                    $narr[$x][$y] = "#";
                } else {
                    $narr[$x][$y] = "|";
                }
            } elsif ($grid[$x][$y] eq "#") {
                if (countAround($x, $y, "#") >= 1 and countAround($x, $y, "|") >= 1) {
                    $narr[$x][$y] = "#";
                } else {
                    $narr[$x][$y] = "."
                }
            }
        }
    }
    @grid = @narr;
}



say countRV();
