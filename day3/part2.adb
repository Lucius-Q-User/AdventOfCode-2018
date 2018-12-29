with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Strings.Unbounded;
use Ada.Strings.Unbounded;
with Ada.Containers.Ordered_Sets;

procedure Part2 is
   package Int_Set is new Ada.Containers.Ordered_Sets(Integer);
   use Int_Set;

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
   Id : Integer;
   No_Overlaps : Set;
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
      Id := Integer'Value(Slice(Line, 2, At_Pos - 2));
      Include(No_Overlaps, Id);
      for X in Integer range OX..(OX + LX) loop
         for Y in Integer range OY..(OY + LY) loop
            if Fabric(X, Y) = 0 then
               Fabric(X, Y) := Id;
            else
               Exclude(No_Overlaps, Fabric(X, Y));
               Exclude(No_Overlaps, Id);
            end if;
         end loop;
      end loop;
   end loop;
   Put_Line(Integer'Image(First_Element(No_Overlaps)));
end Part2;
