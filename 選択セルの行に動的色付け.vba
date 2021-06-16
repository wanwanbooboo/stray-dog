
Private Sub Worksheet_SelectionChange(ByVal Target As Range)
    
    Dim before_row As Integer
    Dim before_col As Integer
    Dim now_row As Integer
    Dim now_col As Integer
    Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim myrange1 As Range
    Set ws1 = Worksheets("一覧")
    Set ws2 = Worksheets("Sheet1")
    Dim myrange As Range
    Set myrange = Union(ws1.Range("A6:BN33"), ws1.Range("BQ6:DZ33"), ws1.Range("EC6:GJ33"))
    Dim before_selected As Range
    Dim now_selected As Range
    
    before_row = ws2.Range("A1").Value
    before_col = ws2.Range("B1").Value
    Set before_selected = ws1.Range(ws1.Cells(before_row, 1), ws1.Cells(before_row, 192))

    With Intersect(before_selected, myrange).Borders
        .Color = RGB(0, 0, 0)
        .LineStyle = xlDot
        .Weight = xlThin
    End With
    
    If Not Intersect(Target, myrange) Is Nothing Then
    
        now_row = Target.row
        now_col = Target.Column
        Set now_selected = ws1.Range(ws1.Cells(now_row, 1), ws1.Cells(now_row, 192))
        
        With Intersect(now_selected, myrange).Borders(xlEdgeTop)
            .Color = RGB(255, 0, 0)
            .LineStyle = xlContinuous
            .Weight = xlMedium
        End With
        With Intersect(now_selected, myrange).Borders(xlEdgeLeft)
            .Color = RGB(255, 0, 0)
            .LineStyle = xlContinuous
            .Weight = xlMedium
        End With
        With Intersect(now_selected, myrange).Borders(xlEdgeBottom)
            .Color = RGB(255, 0, 0)
            .LineStyle = xlContinuous
            .Weight = xlMedium
        End With
        With Intersect(now_selected, myrange).Borders(xlEdgeRight)
            .Color = RGB(255, 0, 0)
            .LineStyle = xlContinuous
            .Weight = xlMedium
        End With
        
        ws2.Range("A1").Value = now_row
        ws2.Range("B1").Value = now_col
     End If
     
     Set ws1 = Nothing
     Set ws2 = Nothing
    

End Sub

