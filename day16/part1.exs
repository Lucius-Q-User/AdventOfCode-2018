defmodule Part1 do
  use Bitwise, only_operators: true
  def main() do
    [teststr, _] = String.split File.read!("in.txt"), "\n\n\n\n"
    cases = Enum.map String.split(teststr, "\n\n"), &Part1.parsetest/1
    testr = Enum.map cases, &Part1.runOpc/1
    testc = Enum.map testr, &Enum.count(&1, fn x -> x end)
    Enum.count(testc, fn x -> x >=3 end)
  end
  def parsetest(st) do
    [befores, opcodess, afters] = String.split st, "\n"
    [i0, i1, i2, i3] = Enum.map String.split(String.slice(befores, 9..-2), ", "), &String.to_integer/1
    [o0, o1, o2, o3] = Enum.map String.split(String.slice(afters, 9..-2), ", "), &String.to_integer/1
    [opc, rin1, rin2, rout] = Enum.map String.split(opcodess, " "), &String.to_integer/1
    {{i0, i1, i2, i3}, {o0, o1, o2, o3}, {opc, rin1, rin2, rout}}
  end
  def ckno({i, o, {_, _, _, 0}}) do
    elem(i, 1) == elem(o, 1) && elem(i, 2) == elem(o, 2) && elem(i, 3) == elem(o, 3)
  end
  def ckno({i, o, {_, _, _, 1}}) do
    elem(i, 0) == elem(o, 0) && elem(i, 2) == elem(o, 2) && elem(i, 3) == elem(o, 3)
  end
  def ckno({i, o, {_, _, _, 2}}) do
    elem(i, 0) == elem(o, 0) && elem(i, 1) == elem(o, 1) && elem(i, 3) == elem(o, 3)
  end
  def ckno({i, o, {_, _, _, 3}}) do
    elem(i, 0) == elem(o, 0) && elem(i, 1) == elem(o, 1) && elem(i, 2) == elem(o, 2)
  end
  def cknw(f) do
    fn (ts) ->
      ckno(ts) && f.(ts)
    end
  end
  def addr({i, o, {_, rin1, rin2, rout}}) do
    elem(o, rout) == elem(i, rin1) + elem(i, rin2)
  end
  def addi({i, o, {_, rin1, iin1, rout}}) do
    elem(o, rout) == elem(i, rin1) + iin1
  end
  def mulr({i, o, {_, rin1, rin2, rout}}) do
    elem(o, rout) == elem(i, rin1) * elem(i, rin2)
  end
  def muli({i, o, {_, rin1, iin1, rout}}) do
    elem(o, rout) == elem(i, rin1) * iin1
  end
  def banr({i, o, {_, rin1, rin2, rout}}) do
    elem(o, rout) == (elem(i, rin1) &&& elem(i, rin2))
  end
  def bani({i, o, {_, rin1, iin1, rout}}) do
    elem(o, rout) == (elem(i, rin1) &&& iin1)
  end
  def borr({i, o, {_, rin1, rin2, rout}}) do
    elem(o, rout) == (elem(i, rin1) ||| elem(i, rin2))
  end
  def bori({i, o, {_, rin1, iin1, rout}}) do
    elem(o, rout) == (elem(i, rin1) ||| iin1)
  end
  def setr({i, o, {_, rin1, _, rout}}) do
    elem(o, rout) == elem(i, rin1)
  end
  def seti({_, o, {_, iin1, _, rout}}) do
    elem(o, rout) == iin1
  end
  def gtir({i, o, {_, iin1, rin1, rout}}) do
    elem(o, rout) == b2i(iin1 > elem(i, rin1))
  end
  def gtri({i, o, {_, rin1, iin1, rout}}) do
    elem(o, rout) == b2i(elem(i, rin1) > iin1)
  end
  def gtrr({i, o, {_, rin1, rin2, rout}}) do
    elem(o, rout) == b2i(elem(i, rin1) > elem(i, rin2))
  end
  def eqir({i, o, {_, iin1, rin1, rout}}) do
    elem(o, rout) == b2i(iin1 == elem(i, rin1))
  end
  def eqri({i, o, {_, rin1, iin1, rout}}) do
    elem(o, rout) == b2i(elem(i, rin1) == iin1)
  end
  def eqrr({i, o, {_, rin1, rin2, rout}}) do
    elem(o, rout) == b2i(elem(i, rin1) == elem(i, rin2))
  end
  def b2i(bool) do
    if bool, do: 1, else: 0
  end
  def runOpc(ts) do
    fns = Enum.map [&Part1.addr/1, &Part1.addi/1, &Part1.mulr/1, &Part1.muli/1, &Part1.banr/1, &Part1.bani/1, &Part1.borr/1, &Part1.bori/1, &Part1.setr/1, &Part1.seti/1, &Part1.gtir/1, &Part1.gtri/1, &Part1.gtrr/1, &Part1.eqir/1, &Part1.eqri/1, &Part1.eqrr/1], &Part1.cknw/1
    Enum.map fns, fn (f) -> f.(ts) end
  end

end

IO.inspect Part1.main
