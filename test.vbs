
Set objFSO = CreateObject("Scripting.FileSystemObject")
Const ForAppending = 8
Const MaxCols = 40
Const InputFileName = "10.xml"
Const OutputFileName = "output.csv"

Set regex_cell = CreateObject("VBScript.RegExp")
regex_cell.Global = true
regex_cell.Pattern = "<Cell ss:Index=\""(\d+)\""[^>]*><Data[^>]*>(.*?)<\/Data><\/Cell>"

Function HTMLDecode(sText)
    Dim regEx
    Dim matches
    Dim match
    sText = Replace(sText, "&quot;", Chr(34))
    sText = Replace(sText, "&lt;"  , Chr(60))
    sText = Replace(sText, "&gt;"  , Chr(62))
    sText = Replace(sText, "&amp;" , Chr(38))
    sText = Replace(sText, "&nbsp;", Chr(32))

    Set regEx= New RegExp

    With regEx
     .Pattern = "&#(\d+)" 'Match html unicode escapes
     .Global = True
    End With

    Set matches = regEx.Execute(sText)

    'Iterate over matches
    For Each match in matches
        'For each unicode match, replace the whole match, with the ChrW of the digits.

        sText = Replace(sText, match.Value, ChrW(match.SubMatches(0)))
    Next

    HTMLDecode = sText
End Function

Function CleanData(value_str)
    value_str = Replace(value_str,"&#10"," ")
    If InStr(value_str, "&#") > 0 Then
        value_str = HTMLDecode(value_str)
    end if
    CleanData = trim(value_str)
End Function 

Function csv_row(row_local)
    Dim result(40)
    Set cell_match = regex_cell.Execute(row_local)
    changed = false
    for i = 0 To cell_match.Count - 1
        if cell_match(i).SubMatches.Count = 2 then
            col = cell_match(i).SubMatches.Item(0)
            value = cell_match(i).SubMatches.Item(1)

            result(col) = """" + CleanData(value) + """"
            changed = true
            ' WScript.Echo(col)
            ' WScript.Echo(value)
        end if
    Next
    if changed then
        csv_row = join(result,";")
    else 
        csv_row = ""
    end if
End Function

function logit(message)
    Set logFile = objFSO.OpenTextFile(OutputFileName, ForAppending, True)
    logFile.WriteLine(message)
    logFile.Close
End Function

With CreateObject("ADODB.Stream")
    .CharSet = "utf-8"
    .Open
    .LoadFromFile(InputFileName)

    row = ""
    buffer = ""
    buffer_fill = false
    row_fill = false

    cnt = 0 
    Do Until .EOS
        one_char = .ReadText(1)
        if one_char = "<" then
            buffer_fill = true
        End if

        if buffer_fill then
            buffer = buffer + one_char
        end if

        if row_fill then
            row = row + one_char
        end if

        if one_char = ">" then
            ' WScript.Echo(buffer)
            if Left(buffer,5) = "<Row " then
                row = buffer
                row_fill = true
            end if
            if buffer = "</Row>" then
                'WScript.Echo(row)

                result_csv_row = csv_row(row)
                if result_csv_row <> "" then
                    WScript.Echo(result_csv_row)
                    logit(result_csv_row)
                end if

                cnt = cnt + 1
                if cnt mod 1000 = 0 then  
                    WScript.Echo(cnt)
                end if

                row = ""
                row_fill = false
            end if
            buffer_fill = false
            buffer = ""
        End if
    Loop

    .Close
End With
