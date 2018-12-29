defmodule Part2 do
  use Bitwise, only_operators: true

  def addr({i, {_, rin1, rin2, rout}}) do
    put_elem i, rout, (elem(i, rin1) + elem(i, rin2))
  end
  def addi({i, {_, rin1, iin1, rout}}) do
    put_elem i, rout, (elem(i, rin1) + iin1)
  end
  def mulr({i, {_, rin1, rin2, rout}}) do
    put_elem i, rout, (elem(i, rin1) * elem(i, rin2))
  end
  def muli({i, {_, rin1, iin1, rout}}) do
    put_elem i, rout, (elem(i, rin1) * iin1)
  end
  def banr({i, {_, rin1, rin2, rout}}) do
    put_elem i, rout, (elem(i, rin1) &&& elem(i, rin2))
  end
  def bani({i, {_, rin1, iin1, rout}}) do
    put_elem i, rout, (elem(i, rin1) &&& iin1)
  end
  def borr({i, {_, rin1, rin2, rout}}) do
    put_elem i, rout, (elem(i, rin1) ||| elem(i, rin2))
  end
  def bori({i, {_, rin1, iin1, rout}}) do
    put_elem i, rout, (elem(i, rin1) ||| iin1)
  end
  def setr({i, {_, rin1, _, rout}}) do
    put_elem i, rout, elem(i, rin1)
  end
  def seti({i, {_, iin1, _, rout}}) do
    put_elem i, rout, iin1
  end
  def gtir({i, {_, iin1, rin1, rout}}) do
    put_elem i, rout, b2i(iin1 > elem(i, rin1))
  end
  def gtri({i, {_, rin1, iin1, rout}}) do
    put_elem i, rout, b2i(elem(i, rin1) > iin1)
  end
  def gtrr({i, {_, rin1, rin2, rout}}) do
    put_elem i, rout, b2i(elem(i, rin1) > elem(i, rin2))
  end
  def eqir({i, {_, iin1, rin1, rout}}) do
    put_elem i, rout, b2i(iin1 == elem(i, rin1))
  end
  def eqri({i, {_, rin1, iin1, rout}}) do
    put_elem i, rout, b2i(elem(i, rin1) == iin1)
  end
  def eqrr({i, {_, rin1, rin2, rout}}) do
    put_elem i, rout, b2i(elem(i, rin1) == elem(i, rin2))
  end
  def checker(f) do
    fn ({i, o, opc}) -> o == f.({i, opc}) end
  end
  def b2i(bool) do
    if bool, do: 1, else: 0
  end
  @functions [&Part2.addr/1, &Part2.addi/1, &Part2.mulr/1, &Part2.muli/1, &Part2.banr/1, &Part2.bani/1, &Part2.borr/1, &Part2.bori/1, &Part2.setr/1, &Part2.seti/1, &Part2.gtir/1, &Part2.gtri/1, &Part2.gtrr/1, &Part2.eqir/1, &Part2.eqri/1, &Part2.eqrr/1]
  def main() do
    [teststr, codestr] = String.split File.read!("in.txt"), "\n\n\n\n"
    code = Enum.map (String.split (String.trim codestr), "\n"), &parseCode/1
    cases = Enum.map String.split(teststr, "\n\n"), &parsetest/1
    candidates = List.to_tuple for _ <- 0..15, do: (for _ <- 0..15, do: true)
    afterTests = Enum.reduce cases, candidates, &runOpc/2
    runner = runInsn playSudoku tupleMap(afterTests, &List.to_tuple/1)
    endstate = Enum.reduce code, {0, 0, 0, 0}, runner
    elem endstate, 0
  end
  def parseCode(ln) do
    ls = String.split ln, " "
    List.to_tuple Enum.map(ls, &String.to_integer/1)
  end
  def runInsn(map) do
    fn (cmd, reg) ->
      opc = elem(cmd, 0)
      map[opc].({reg, cmd})
    end
  end
  def playSudoku(grid) do
    case pickOne(grid) do
      [opc | _] ->
        insn = Enum.find_index(Tuple.to_list(elem(grid, opc)), &(&1))
        ngrid = tupleMap(grid, fn (r) -> put_elem(r, insn, false) end)
        Map.put(playSudoku(ngrid), opc, Enum.at(@functions,insn))
      [] -> %{}
    end
  end
  def pickOne(grid) do
    filter = fn(n) -> Enum.count(Tuple.to_list(elem(grid, n)), &(&1)) == 1 end
    (for i <- 0..15, filter.(i), do: i)
  end
  def parsetest(st) do
    [befores, opcodess, afters] = String.split st, "\n"
    [i0, i1, i2, i3] = Enum.map String.split(String.slice(befores, 9..-2), ", "), &String.to_integer/1
    [o0, o1, o2, o3] = Enum.map String.split(String.slice(afters, 9..-2), ", "), &String.to_integer/1
    [opc, rin1, rin2, rout] = Enum.map String.split(opcodess, " "), &String.to_integer/1
    {{i0, i1, i2, i3}, {o0, o1, o2, o3}, {opc, rin1, rin2, rout}}
  end
  def runOpc(ts, cands) do
    {_, _, {opc, _, _, _}} = ts
    opcand = elem(cands, opc)
    fns = Enum.map @functions, &checker/1
    nopcand = zipMap(fns, opcand, fn f, tv -> tv and f.(ts) end)
    put_elem cands, opc, nopcand
  end
  def zipMap(enum1, enum2, f) do
    Enum.map Enum.zip(enum1, enum2), fn {a, b} -> f.(a, b) end
  end
  def tupleMap(tuple, f) do
    List.to_tuple(Enum.map((Tuple.to_list tuple), f))
  end
end

IO.inspect Part2.main
