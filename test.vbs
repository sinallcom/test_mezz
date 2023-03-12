Const adReadLine = -2

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
