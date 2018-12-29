Dim accm As Integer, f As Integer, scr As Integer
Dim freqs() As Integer
Dim reps() As Integer
Dim repsz As Integer
Dim freqsz As Integer
Dim i As Integer
Dim j As Integer
repsz = 0
accm = 0
freqsz = 0
f = FreeFile
Open "in.txt" For Input as #f

Do Until EOF(f)
    Input #f, scr
    freqsz += 1
    ReDim Preserve freqs(1 To freqsz)
    freqs(freqsz) = scr
Loop

Do
    For i = 1 To freqsz
        accm += freqs(i)
        For j = 1 To repsz
            If reps(j) = accm Then
                Print accm
                Exit Do
            Else
                repsz += 1
                ReDim Preserve reps(1 To repsz)
                reps(repsz) = accm
            End If
        Next j
    Next i
Loop
