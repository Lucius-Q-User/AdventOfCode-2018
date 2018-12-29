{$mode delphi}
{$R+}
program part1;
var
   gridSerial : integer;
   x : integer;
   y : integer;
   gs : integer;
   mgs : integer;
   mxi : integer;
   myi : integer;
   mv : integer;
   cv : integer;


function doCell(x: integer; y: integer; gridSerial: integer): integer;
var
    rackId: integer;
begin
    rackId := x + 10;
    doCell := ((((rackId * y + gridSerial) * rackId) div 100) mod 10) - 5;
end;

function doGrid(x: integer; y: integer; gridSize: integer; gridSerial: integer): integer;
var
    accm: integer;
    i: integer;
    j: integer;
begin
    accm := 0;
    for i := 0 to gridSize - 1 do begin
        for j := 0 to gridSize - 1 do begin
            accm := accm + doCell(x + i, y + j, gridSerial);
        end;
    end;
    doGrid := accm;
end;

begin
   readln(gridSerial);
   mv := -10000000;
   for gs := 1 to 300 do begin
       for x := 1 to 301 - gs do begin
           for y := 1 to 301 - gs do begin
               cv := doGrid(x, y, gs, gridSerial);
               if cv > mv then begin
                  mv := cv;
                  myi := y;
                  mxi := x;
                  mgs := gs;
               end;
           end;
       end;
   end;
   writeln(mxi, ',', myi, ',', mgs);
end.
