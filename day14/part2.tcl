set nrec [gets stdin]

set lastx [string length nrec]

set nrec [split $nrec ""]

puts $nrec

set board {3 7}
set elf1 0
set elf2 1

proc lequal {l1 l2} {
    for {set i 0} {$i < [llength $l1]} {incr i} {
        if {[lindex $l1 $i] != [lindex $l2 $i]} {
            return false
        }
    }
    return true
}

while true {
    if {[llength board] % 10000 == 0} {
        puts [llength board]
    }
    set merge [expr [lindex $board $elf1] + [lindex $board $elf2]]
    if {$merge > 9} {
        lappend board [expr $merge / 10]
    }
    lappend board [expr $merge % 10]
    set elf1 [expr ($elf1 + [lindex $board $elf1] + 1) % [llength $board]]
    set elf2 [expr ($elf2 + [lindex $board $elf2] + 1) % [llength $board]]
    set lplace [lrange $board end-$lastx end]
    if [lequal $lplace $nrec] {
        puts [expr [llength $board] - $lastx - 1]
        break
    }
}
