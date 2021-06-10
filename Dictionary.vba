Option Explicit

Sub Vlookup()

    Dim myDic As Object
    Set myDic = CreateObject("Scripting.Dictionary")
    Dim i As Integer
    Dim j As Integer
    Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim ws3 As Worksheet
    Set ws1 = Worksheets("練習用")
    Set ws2 = Worksheets("Sheet1")
    Dim col_num As Integer
    Dim starttime As Single
    Dim endtime As Single
    
    starttime = Timer
    
    Worksheets.Add(after:=Worksheets(Worksheets.Count)).Name = "抽出データ" & Worksheets.Count
    Set ws3 = Worksheets("抽出データ" & Worksheets.Count - 1)
    
    
    With ws2
    For i = 1 To .Cells(Rows.Count, 1).End(xlUp).Row
        If Not myDic.exists(.Cells(i, 1).Value) Then
            myDic.Add .Cells(i, 1).Value, .Cells(i, 2).Value
        End If
    Next i
    End With
    
    With ws1
    j = 1
    col_num = .Cells(1, Columns.Count).End(xlToLeft).Column
    For i = .Cells(Rows.Count, 1).End(xlUp).Row To 1 Step -1
        If Not myDic.exists(.Cells(i, 1).Value) Then
            ws3.Range(ws3.Cells(j, 1), ws3.Cells(j, col_num)).Value = .Range(.Cells(i, 1), .Cells(i, col_num)).Value
            j = j + 1
            Range(.Cells(i, 1), .Cells(i, col_num)).Delete
        End If
    Next i
    End With
    
    With ws3
        .Range("A1").Sort key1:=.Range("A1"), order1:=xlAscending, Header:=xlNo
    End With
    
    endtime = Timer

    If j = 1 Then
        MsgBox "There is no difference between the two sheets in Employee Code."
    Else
        MsgBox "Process time: " & endtime - starttime
    End If
    
    Set myDic = Nothing
    Set ws1 = Nothing
    Set ws2 = Nothing
    Set ws3 = Nothing

End Sub

