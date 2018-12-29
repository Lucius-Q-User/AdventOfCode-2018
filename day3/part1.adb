with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;

procedure Part1 is
   function Find_Char(Needle: Character; Haystack: Unbounded_String) return Integer is
   begin
      for I in Integer range 1..Length(Haystack) loop
         if Element(Haystack, I) = Needle then
            return I;
         end if;
      end loop;
      return Integer'Last;
   end Find_Char;

   Fabric : array (Positive range 1..1000, Positive range 1..1000) of Integer := (others => (others => 0));
   Line : Unbounded_String;
   File : File_Type;
   Comma_Pos : Integer;
   At_Pos : Integer;
   Colon_Pos : Integer;
   X_Pos : Integer;
   OX : Integer;
   OY : Integer;
   LX : Integer;
   LY : Integer;
   Ctr : Integer;
begin
   Open(File => File, Mode => In_File, Name => "in.txt");
   while not End_Of_File(File) loop
      Line := To_Unbounded_String(Get_Line(File));
      Comma_Pos := Find_Char(',', Line);
      At_Pos := Find_Char('@', Line);
      Colon_Pos := Find_Char(':', Line);
      X_Pos := Find_Char('x', Line);
      OX := Integer'Value(Slice(Line, At_Pos + 2, Comma_Pos - 1)) + 1;
      OY := Integer'Value(Slice(Line, Comma_Pos + 1, Colon_Pos - 1)) + 1;
      LX := Integer'Value(Slice(Line, Colon_Pos + 2, X_Pos - 1)) - 1;
      LY := Integer'Value(Slice(Line, X_Pos + 1, Length(Line))) - 1;
      for X in Integer range OX..(OX + LX) loop
         for Y in Integer range OY..(OY + LY) loop
            Fabric(X, Y) := Fabric(X, Y) + 1;
         end loop;
      end loop;
   end loop;
   Ctr := 0;
   for X in Integer range 1..1000 loop
      for Y in Integer range 1..1000 loop
         if Fabric(X, Y) > 1 then
            Ctr := Ctr + 1;
         end if;
      end loop;
   end loop;
   Put_Line(Integer'Image(Ctr));
end Part1;
