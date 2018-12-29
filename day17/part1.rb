grid = []

2000.times do ||
  line = []
  2000.times do ||
    line << '.'
  end
  grid << line
end
File.open("in.txt") do |f|
  f.each_line do |line|
    if line[0] == "x"
      x = line[2..-1].split(",")[0].to_i
      rang = line.split("y=")[1].split("..")
      sy = rang[0].to_i
      ey = rang[1].to_i
      for i in sy..ey do
        grid[i][x] = "#"
      end
    else
      y = line[2..-1].split(",")[0].to_i
      rang = line.split("x=")[1].split("..")
      sx = rang[0].to_i
      ex = rang[1].to_i
      for i in sx..ex do
        grid[y][i] = "#"
      end
    end
  end
end

grid[0][500] = "|"

to_visit = [[0, 500]]

while !to_visit.empty? do
  (y, x) = to_visit.pop()
  if grid[y + 1] == nil
    next
  end
  if grid[y][x] == "|" && grid[y + 1][x] == "."
    grid[y + 1][x] = "|"
    to_visit << [y + 1, x]
  end
  if grid[y][x] == "~"
    if grid[y][x + 1] == "." || grid[y][x + 1] == "|"
      grid[y][x + 1] = "~"
      to_visit << [y, x + 1]
      to_visit << [y - 1, x + 1]
    end
    if grid[y][x - 1] == "." || grid[y][x - 1] == "|"
      grid[y][x - 1] = "~"
      to_visit << [y, x - 1]
      to_visit << [y - 1, x - 1]
    end
  end
  if grid[y][x] == "|" && (grid[y + 1][x] == "~" || grid[y + 1][x] == "#")
    fx = x
    spill = false
    while true do
      fx += 1
      if grid[y][fx] == "." || grid[y][fx] == "|"
        if !(grid[y + 1][fx] == "#" || grid[y + 1][fx] == "~")
          spill = true
          break
        end
      else
        break
      end
    end
    fx = x
    while !spill do
      fx -= 1
      if grid[y][fx] == "." || grid[y][fx] == "|"
        if !(grid[y + 1][fx] == "#" || grid[y + 1][fx] == "~")
          spill = true
          break
        end
      else
        break
      end
    end
    if !spill
      grid[y][x] = "~"
      to_visit << [y, x]
      to_visit << [y - 1, x]
      fx = x + 1
      while grid[y][fx] == "." do
        grid[y][fx] = "~"
        to_visit << [y, fx]
        to_visit << [y - 1, fx]
        fx += 1
      end
      fx = x - 1
      while grid[y][fx] == "." do
        grid[y][fx] = "~"
        to_visit << [y, fx]
        to_visit << [y - 1, fx]
        fx -= 1
      end
    else
      fx = x + 1
      while grid[y][fx] == "." do
        grid[y][fx] = "|"
        to_visit << [y, fx]
        if grid[y + 1][fx] == "."
          break
        end
        fx += 1;
      end
      fx = x - 1
      while grid[y][fx] == "." do
        grid[y][fx] = "|"
        to_visit << [y, fx]
        if grid[y + 1][fx] == "."
          break
        end
        fx -= 1;
      end
    end
  end
end


accm = 0

start = nil
endl = 0

for i in 0..(grid.length - 1)
  if grid[i].include? "#"
    if start == nil
      start = i
    end
    endl = i
  end
end

grid[start..endl].each do |line|
  line.each do |item|
    if item == "~" || item == "|"
      accm += 1
    end
  end
end
puts accm
