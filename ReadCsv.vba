Option Explicit


Sub ReadCSV()

    Dim varFileName As Variant
    Dim intFree As Integer
    Dim strRec As String
    Dim strSplit() As String
    Dim i As Long, j As Long


    varFileName = Application.GetOpenFilename(FileFilter:="CSVファイル(*.csv),*.csv", _
                                                Title:="CSVファイルの選択")
    If varFileName = False Then
        Exit Sub
    End If

    intFree = FreeFile '空番号を取得
    Open varFileName For Input As #intFree 'CSVファィルをオープン
  
    i = 0
    Do Until EOF(intFree)
        Line Input #intFree, strRec '1行読み込み
        i = i + 1
        strSplit = Split(strRec, ",") 'カンマ区切りで配列へ
        For j = 0 To UBound(strSplit)
            Cells(i, j + 1) = strSplit(j)
        Next
        '配列をそのまま入れる方法も、ただし全て文字列として入力される
        'Range(Cells(i, 1), Cells(i, UBound(strSplit) + 1)) = strSplit
    Loop
  
    Close #intFree

End Sub
