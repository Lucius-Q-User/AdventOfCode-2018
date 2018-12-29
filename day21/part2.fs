variable ip

variable insn-count
0 insn-count !

variable insns 100 cells allot

variable rina 100 cells allot
variable rinb 100 cells allot
variable rout 100 cells allot

variable cd
20000 cd !

: cke cd @ 0= if bye then cd @ 1 - cd ! ;

variable reg-state 6 cells allot
reg-state 6 cells 0 fill

: fix-bool -1 * ;

: reg cells reg-state + ;

: readint parse-name s>number drop ;

: #ip readint ip ! ;

: seti! swap drop reg ! ;

: bani! rot reg @ rot and swap reg ! ;

: addr! rot reg @ rot reg @ + swap reg ! ;

: bori! rot reg @ rot or swap reg ! ;

: muli! rot reg @ rot * swap reg ! ;

: addi! rot reg @ rot + swap reg ! ;

: setr! swap drop swap reg @ swap reg ! ;

: eqri! rot reg @ rot = fix-bool swap reg ! ;

: eqrr! 0 swap reg ! drop reg @ . cr cke ;

: gtir! -rot reg @ > fix-bool swap reg ! ;

: gtrr! -rot reg @ swap reg @ swap > fix-bool swap reg ! ;

: load-regs
  ip @ reg @ cells rina + @
  ip @ reg @ cells rinb + @
  ip @ reg @ cells rout + @
;

: interp-loop
  begin
    load-regs
    ip @ reg @ cells insns + @ execute
    ip @ reg @ 1 + ip @ reg !
    0
  until
;

: compile-insn
  insn-count @ cells insns + !
  readint insn-count @ cells rina + !
  readint insn-count @ cells rinb + !
  readint insn-count @ cells rout + !
  insn-count @ 1+ insn-count !
;


: seti [ ' seti! ] literal compile-insn ;
: bani [ ' bani! ] literal compile-insn ;
: addr [ ' addr! ] literal compile-insn ;
: bori [ ' bori! ] literal compile-insn ;
: muli [ ' muli! ] literal compile-insn ;
: addi [ ' addi! ] literal compile-insn ;
: setr [ ' setr! ] literal compile-insn ;
: eqri [ ' eqri! ] literal compile-insn ;
: eqrr [ ' eqrr! ] literal compile-insn ;
: gtir [ ' gtir! ] literal compile-insn ;
: gtrr [ ' gtrr! ] literal compile-insn ;

include in.txt

interp-loop
