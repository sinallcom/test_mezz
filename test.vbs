Const adReadLine = -2

With CreateObject("ADODB.Stream")
    .CharSet = "utf-8"
    .Open
    .LoadFromFile "input.txt"

    row = ""
    buffer = ""
    buffer_fill = false
    row_fill = false
    Do Until .EOS
        char = .ReadText(1)
        if char = "<" then
            buffer_fill = true
        End if

        if buffer_fill then
            buffer = buffer + char
        end if

        if row_fill then
            row = row + char
        end if

        if char = ">" then
            ' WScript.Echo(buffer)
            if buffer = "<Row>" then
                row = buffer
                row_fill = true
            end if
            if buffer = "</Row>" then
                WScript.Echo(row)
                row = ""
                row_fill = false
            end if
            buffer_fill = false
            buffer = ""
        End if
    Loop

    .Close
End With
