{$mode delphi}
{$R+}
program part1;
var
   gridSerial : integer;
   x : integer;
   y : integer;
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

function doGrid(x: integer; y: integer; gridSerial: integer): integer;
var 
    accm: integer;
    i: integer;
    j: integer;
begin
    accm := 0;
    for i := 0 to 2 do begin
        for j := 0 to 2 do begin
            accm := accm + doCell(x + i, y + j, gridSerial);
        end;
    end;
    doGrid := accm;
end;

begin
   readln(gridSerial);
   mv := -10000000;
   
   for x := 1 to 298 do begin
       for y := 1 to 298 do begin
           cv := doGrid(x, y, gridSerial);
           if cv > mv then begin
               mv := cv;
               myi := y;
               mxi := x;
           end;
       end;
   end;
   writeln(mxi, ',', myi);
end.
