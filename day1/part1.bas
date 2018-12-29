Dim accm As Integer, f As Integer, scr As Integer
accm = 0
f = FreeFile
Open "in.txt" For Input as #f

Do Until EOF(f)
    Input #f, scr
    accm += scr
Loop

print accm