#load "str.cma";;
let read_file () =
  let lines = ref [] in
  let code = open_in "in.txt" in
  try
    while true; do
      lines := input_line code :: !lines
    done; !lines
  with End_of_file ->
    close_in code;
    List.rev !lines
let addi r i o state =
  state.(o) <- state.(r) + i;
  state
let seti i _ o state =
  state.(o) <- i;
  state
let mulr ra rb o state =
  state.(o) <- state.(ra) * state.(rb);
  state
let eqrr ra rb o state =
  state.(o) <- if state.(ra) = state.(rb) then 1 else 0;
  state
let addr ra rb o state =
  state.(o) <- state.(ra) + state.(rb);
  state
let gtrr ra rb o state =
  state.(o) <- if state.(ra) > state.(rb) then 1 else 0;
  state
let muli r i o state =
  state.(o) <- state.(r) * i;
  state
let setr r _ o state =
  state.(o) <- state.(r);
  state
let rec exec ip_reg insn ip state =
  state.(ip_reg) <- ip;
  let ns = insn.(ip) state in
  let nip = ns.(ip_reg) + 1 in
  if nip < 0 || nip >= Array.length insn then state else
    exec ip_reg insn nip ns

let get_opc_fn opc =
  match opc with
  | "addi" -> addi
  | "seti" -> seti
  | "mulr" -> mulr
  | "eqrr" -> eqrr
  | "addr" -> addr
  | "gtrr" -> gtrr
  | "muli" -> muli
  | "setr" -> setr

let split_wspace = Str.split (Str.regexp "[ \n\r\x0c\t]+")

let parse_insn istr =
  let [opc; ra; rb; rc] = split_wspace istr in
  (get_opc_fn opc) (int_of_string ra) (int_of_string rb) (int_of_string rc)

let main () =
  let ipb::code = read_file () in
  let _::rg::_ = split_wspace ipb in
  let ip_reg = int_of_string rg in
  let insn = Array.of_list (List.map parse_insn code) in
  let result = exec ip_reg insn 0 [|0; 0; 0; 0; 0; 0|] in
  Printf.printf "%d\n" result.(0);;

;;
main ()
