Option Explicit


Private Sub Worksheet_SelectionChange(ByVal Target As Range)

    Dim before_row As Integer
    Dim before_col As Integer
    Dim now_row As Integer
    Dim now_col As Integer
    Dim ws1 As Worksheet
    Dim ws2 As Worksheet
    Dim myrange1 As Range
    Set ws1 = Worksheets("Sheet1")
    Set ws2 = Worksheets("Sheet2")
    Set myrange1 = ws1.Range("A6:BL33")
    
    
    before_row = ws2.Range("A1").Value
    before_col = ws2.Range("B1").Value

    With ws1.Range(ws1.Cells(before_row, 1), ws1.Cells(before_row, 60)).Borders
        .Color = RGB(0, 0, 0)
        .LineStyle = xlDot
        .Weight = xlThin
    End With
    
    If Not Intersect(Target, myrange1) Is Nothing Then
    
        now_row = Target.Row
        now_col = Target.Column
        
        With ws1.Range(ws1.Cells(now_row, 1), ws1.Cells(now_row, 60)).Borders
            .Color = RGB(255, 0, 0)
            .LineStyle = xlContinuous
            .Weight = xlThick
        End With
        
        ws2.Range("A1").Value = now_row
        ws2.Range("B1").Value = now_col
     End If
     
     Set ws1 = Nothing
     Set ws2 = Nothing
     
End Sub
