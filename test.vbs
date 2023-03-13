
Set objFSO = CreateObject("Scripting.FileSystemObject")
Const ForAppending = 8

Set regex_cell = CreateObject("VBScript.RegExp")
regex_cell.Global = true
regex_cell.Pattern = "<Cell ss:Index=\""(\d+)\""[^>]*><Data[^>]*>(.*?)<\/Data><\/Cell>"

Function csv_row(row_local)
    Dim result(40)
    Set cell_match = regex_cell.Execute(row_local)
    for i = 0 To cell_match.Count - 1
        if cell_match(i).SubMatches.Count = 2 then
            col = cell_match(i).SubMatches.Item(0)
            value = cell_match(i).SubMatches.Item(1)

            result(col) = """" + trim(value) + """"
            WScript.Echo(col)
            WScript.Echo(value)
        end if
    Next
   csv_row = join(result,";") 
End Function

function logit(message)
    Set logFile = objFSO.OpenTextFile("output.csv", ForAppending, True)
    logFile.WriteLine(message)
    logFile.Close
End Function

With CreateObject("ADODB.Stream")
    .CharSet = "utf-8"
    .Open
    .LoadFromFile "10.xml"

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
                WScript.Echo(row)

                WScript.Echo(csv_row(row))
                logit(csv_row(row))

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
