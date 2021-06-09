Sub Vlookup()

    Dim myDic As Object
    Set myDic = CreateObject("Scripting.Dictionary")
    Dim i As Integer
    Dim j As Integer
    Set ws1 = Worksheets("練習用")
    Set ws2 = Worksheets("Sheet1")
    Dim col_num As Integer
    
    Worksheets.Add(after:=Worksheets(Worksheets.Count)).Name = "抽出データ" & Worksheets.Count
    Set ws3 = Worksheets("抽出データ" & Worksheets.Count)
    
    
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
    For i = .Cells(Rows.Count, 4).End(xlUp).Row To 1 Step -1
        If Not myDic.exists(.Cells(i, 8).Value) Then
            ws3.Range(Cells(j, 1), Cells(j, col_num)).Value = .Range(Cells(i, 1), Cells(i, col_num)).Value
            j = j + 1
            .Range(Cells(i, 1), Cells(i, col_num)).Delete
        End If
    Next i
    End With

    If j = 1 Then
        MsgBox "There is no match in Employee Code."
    End If

    Set myDic = Nothing
    Set ws1 = Nothing
    Set ws2 = Nothing
    Set ws3 = Nothing

End Sub
