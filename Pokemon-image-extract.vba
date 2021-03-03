'Win APIの宣言（ファイルダウンロード用）
Declare PtrSafe Function URLDownloadToFile Lib "urlmon" Alias "URLDownloadToFileA" (ByVal pCaller As Long, _
    ByVal szURL As String, _
    ByVal szFileName As String, _
    ByVal dwReserved As Long, _
    ByVal lpfnCB As Long) As Long
    
'Win APIの宣言（キャッシュ削除用）
Declare PtrSafe Function DeleteUrlCacheEntry Lib "wininet" _
    Alias "DeleteUrlCacheEntryA" (ByVal lpszUrlName As String) As LongPtr

#If VBA7 Then '処理を停止するWindows APIのSleep関数を使用できるようにAPIを宣言する、上が64bit版、下が32bit版。
Private Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal ms As LongPtr)
#Else
Private Declare Sub Sleep Lib "kernel32" (ByVal ms As Long)
#End If

'メインルーチン
Sub pokemon_image_list()
        
    Dim objie  As New InternetExplorer
    Dim i As Integer
    Dim j As Integer
    Dim page_num As String
    Dim urlname As String
    Const data_num = 898
    
    For i = 1 To data_num
        
        page_num = Right("0000" & i, 3)
        
        For j = 0 To 3
            If j = 0 Then
                urlname = "https://zukan.pokemon.co.jp/detail/" & page_num
                Call ieView(objie, urlname, True)
                Call fetch_file(objie, i, j)
                objie.Quit
                Sleep 350
            Else
                urlname = "https://zukan.pokemon.co.jp/detail/" & page_num & "-" & Str(j)
                If IsValidURL(urlname) = True Then
                    Call ieView(objie, urlname, True)
                    Call fetch_file(objie, i, j)
                    objie.Quit
                    Sleep 350
                End If
            End If
        Next j
    Next i
End Sub

'IEを作成＆表示させるサブルーチン
Sub ieView(objie As InternetExplorer, urlname As String, Optional viewFlg As Boolean = True)

  'IE(InternetExplorer)のオブジェクトを作成する
  'Set objIE = CreateObject("InternetExplorer.Application")
  Set objie = New InternetExplorerMedium
  'IE(InternetExplorer)を表示・非表示、ここではviewFlgがTrueなので表示、省略したいときはFalseを入れる
  objie.Visible = viewFlg

  '指定したURLのページを表示する
  objie.navigate urlname
 
 'IEが完全表示されるまで待機
 Call ieCheck(objie)

End Sub

'IEの表示状況を確認＆待機するサブルーチン
Sub ieCheck(objie As InternetExplorer)

  Dim timeout As Date

  '完全にページが表示されるまで待機する、（変数timeOutに処理時間+20秒を加算した時間を代入）
  timeout = Now + TimeSerial(0, 0, 20)
    
    'InternetExplorerオブジェクトの状態をチェック
    'Busy=Trueは読み込み中、ReadyStateプロパティの「4」は読み込み完了状態を表す、
  Do While objie.Busy = True Or objie.readyState <> 4
    DoEvents
    Sleep 350 '350 ms待機
    If Now > timeout Then '一定時間経っても読み込まない場合、無限ループを防ぐためRefresh
      objie.Refresh
      timeout = Now + TimeSerial(0, 0, 20)
    End If
  Loop

  timeout = Now + TimeSerial(0, 0, 20)

    'Documentオブジェクトの状態をチェック
  Do While objie.document.readyState <> "complete" 'completeはdocumentオブジェクトの読み込み完了。
    DoEvents
    Sleep 350
    If Now > timeout Then
      objie.Refresh
      timeout = Now + TimeSerial(0, 0, 20)
    End If
   Loop

 '２つのループを抜ければ完全に読み込み完了になる
End Sub

'画像ファイルをスクレイピングするサブルーチン
Sub fetch_file(objie As InternetExplorer, i As Integer, Optional j As Integer)

        Dim imgURL As String
        Dim pokemonName As String
        Dim pokemonSubName As String
        Dim savePath As String
        Dim cacheDel As Long
        Dim result As Long

        '画像URL取得
        imgURL = objie.document.images(3).src
        '今回は画像のクラス名がimageなので以下でもできそう
        'imgURL = objIE.document.getElementsByClassName("image")(3).getAttribute("src")
        
        '画像ファイル名
        'fileName = Mid(imgURL, InStrRev(imgURL, "/") + 1)
        '今回はポケモン名をファイル名にする
        pokemonName = objie.document.getElementsByClassName("name")(0).innerHTML
        pokemonSubName = objie.document.getElementsByClassName("subname")(0).innerHTML
 
        If pokemonSubName = "" Then
            '画像保存先(+画像ファイル名）
            savePath = ActiveWorkbook.Path & "\image_pokemon\" & pokemonName & ".png"
        Else
            savePath = ActiveWorkbook.Path & "\image_pokemon\" & pokemonName & "(" & pokemonSubName & ")" & ".png"
        End If
        
        'キャッシュクリア
        Call DeleteUrlCacheEntry(imgURL)
        
        '画像ダウンロード
        result = URLDownloadToFile(0, imgURL, savePath, 0, 0)
        
        '進行状況確認用
        If result = 0 Then
            If pokemonSubName = "" Then
                Debug.Print i & "-" & j & ":" & pokemonName & "の画像ダウンロード完了"
            Else
                Debug.Print i & "-" & j & ":" & pokemonName & "(" & pokemonSubName & ")" & "の画像ダウンロード完了"
            End If
        Else
            MsgBox i & "-" & j & "番目の画像はダウンロードできませんでした"
        End If
        
End Sub

'URLのページが存在するか確認するサブルーチン
Public Function IsValidURL(sURL As String) As Boolean

    Dim lngResolveTimeout As Long
    Dim lngConnectTimeout As Long
    Dim lngSendTimeout As Long
    Dim lngReceiveTimeout As Long
    
    lngResolveTimeout = 1500
    lngConnectTimeout = 1500
    lngSendTimeout = 1500
    lngReceiveTimeout = 1500
    IsValidURL = False
    Dim objHttpRequest As Object
    Set objHttpRequest = CreateObject("MSXML2.ServerXMLHTTP")
    
    objHttpRequest.setTimeouts lngResolveTimeout, lngConnectTimeout, lngSendTimeout, lngReceiveTimeout
    
    On Error GoTo ErrIsValidURL
    objHttpRequest.Open "GET", sURL
    objHttpRequest.send
    
    Select Case objHttpRequest.Status
        Case 200 '問題なし
'            Debug.Print " Valid:" & sURL
            IsValidURL = True
        Case 404 'ページなし
'            Debug.Print "Invalid:" & sURL
        Case Else 'その他の問題
            Debug.Print " Error:" & sURL '"An unexpected HTTP Status value was returned: " & objHttpRequest.Status
    End Select
    
    Set objHttpRequest = Nothing

ExitIsValidURL:
    Exit Function
    
ErrIsValidURL:
    Debug.Print " Error:" & sURL
    Debug.Print " " & Err & ":" & Error$
    Resume ExitIsValidURL
    
End Function
