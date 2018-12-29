set nrec [gets stdin]

set stop [expr {$nrec + 10}]

set board {3 7}
set elf1 0
set elf2 1

while {[llength $board] < $stop} {
    set merge [expr [lindex $board $elf1] + [lindex $board $elf2]]
    set temp {}
    if {$merge > 9} {
        lappend board [expr $merge / 10]
    }
    lappend board [expr $merge % 10]
    set elf1 [expr ($elf1 + [lindex $board $elf1] + 1) % [llength $board]]
    set elf2 [expr ($elf2 + [lindex $board $elf2] + 1) % [llength $board]]
}

puts [string cat {*}[lrange $board end-9 end]]
