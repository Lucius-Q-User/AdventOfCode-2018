local io = require("io")
local os = require("os")
getmetatable('').__index = function(str,i) return string.sub(str,i,i) end
LEFT = 0
STRAIGHT = 1
RIGHT = 2
gridtrans = {
   ["|"] = "|",
   ["-"] = "-",
   [" "] = " ",
   ["/"] = "/",
   ["\\"] = "\\",
   ["+"] = "+",
   ["<"] = "-",
   [">"] = "-",
   ["^"] = "|",
   ["v"] = "|"
}

cgridtrans = {
   ["|"] = " ",
   ["-"] = " ",
   [" "] = " ",
   ["/"] = " ",
   ["\\"] = " ",
   ["+"] = " ",
   ["<"] = "<",
   [">"] = ">",
   ["^"] = "^",
   ["v"] = "v"
}

grid = {}
cartgrid = {}
local ncarts = 0
for line in io.lines("in.txt") do
   gline = {}
   cgline = {}
   for i = 1, #line do
      local c = line[i]
      table.insert(gline, gridtrans[c])
      if cgridtrans[c] == " " then
         table.insert(cgline, 0)
      else
         ncarts = ncarts + 1
         table.insert(cgline, { direction = cgridtrans[c], next_turn = LEFT, last_move = 0 })
      end
   end
   table.insert(grid, gline)
   table.insert(cartgrid, cgline)
end

function collide (x, y, cart)
   if cartgrid[x][y] ~= 0 then
      cartgrid[x][y] = 0
      ncarts = ncarts - 2
   else
      cartgrid[x][y] = cart
   end
end

local last_move = 0
while true do
   last_move = last_move + 1
   for x = 1, #grid do
      for y = 1, #(grid[1]) do
         local cart = cartgrid[x][y]
         if cart ~= 0 and cart.last_move ~= last_move then
            cart.last_move = cart.last_move + 1
            cartgrid[x][y] = 0
            local nx = 0
            local ny = 0
            if cart.direction == "^" then
               nx = x - 1
               ny = y
            elseif cart.direction == "v" then
               nx = x + 1
               ny = y
            elseif cart.direction == "<" then
               nx = x
               ny = y - 1
            elseif cart.direction == ">" then
               nx = x
               ny = y + 1
            end
            collide(nx, ny, cart)

            if grid[nx][ny] == "/" then
               cart.direction = ({[">"] = "^", ["v"] = "<", ["<"] = "v", ["^"] = ">"})[cart.direction]
            elseif grid[nx][ny] == "\\" then
               cart.direction = ({[">"] = "v", ["v"] = ">", ["<"] = "^", ["^"] = "<"})[cart.direction]
            elseif grid[nx][ny] == "+" then
               if cart.next_turn == LEFT then
                  cart.direction = ({[">"] = "^", ["v"] = ">", ["<"] = "v", ["^"] = "<"})[cart.direction]
               elseif cart.next_turn == RIGHT then
                  cart.direction = ({[">"] = "v", ["v"] = "<", ["<"] = "^", ["^"] = ">"})[cart.direction]
               end
               cart.next_turn = (cart.next_turn + 1) % 3
            end
         end
      end
   end
   if ncarts == 1 then
      for x = 1, #grid do
         for y = 1, #(grid[1]) do
            if cartgrid[x][y] ~= 0 then
               io.write(y - 1, ",", x - 1, "\n")
               os.exit(0)
            end
         end
      end
   end
end
