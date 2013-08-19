Func echo($in)
    ; ShellExecute("eventcreate", '/L Application /T INFORMATION /SO TurboTools /ID 1 /D "Hello!"', -1, "open", @SW_HIDE)
    ; Note to self - Event Log requires administrator rights
    ConsoleWrite ($in & @CRLF)
    ; ---- console window formatting control
    Local $sLogLineType = StringLeft(StringStripWS($in, 1), 3)
    ; remember - iColor format = 0x00bbggrr
    Switch $sLogLineType
        Case "[!]"
            _GUICtrlRichEdit_SetCharColor_No_Selection($hDebugConsoleTxt, 0x00000099)
        Case "[#]"
            _GUICtrlRichEdit_SetCharColor_No_Selection($hDebugConsoleTxt, 0x00003300)
        Case "[?]"
            _GUICtrlRichEdit_SetCharColor_No_Selection($hDebugConsoleTxt, 0x00550000)
        Case Else
            ; Something else, use black
            _GUICtrlRichEdit_SetCharColor_No_Selection($hDebugConsoleTxt, 0x00000000)
    EndSwitch
    ;_GuiCtrlRichEdit_Deselect($hDebugConsoleTxt)
    _GUICtrlRichEdit_SetFont($hDebugConsoleTxt, 9, "Lucida Console")
    _GUICtrlEdit_AppendText($hDebugConsoleTxt, $in & @CRLF)
EndFunc

Func _GUICtrlRichEdit_SetCharColor_No_Selection($hWnd, $iColor = Default)
    If Not IsHWnd($hWnd) Then Return SetError(101, 0, False)

    Local $tCharFormat = DllStructCreate($tagCHARFORMAT)
    DllStructSetData($tCharFormat, 1, DllStructGetSize($tCharFormat))
    If IsKeyword($iColor) Then
        DllStructSetData($tCharFormat, 3, $CFE_AUTOCOLOR)
        $iColor = 0
    Else
        If BitAND($iColor, 0xff000000) Then Return SetError(1022, 0, False)
    EndIf

    DllStructSetData($tCharFormat, 2, $CFM_COLOR)
    DllStructSetData($tCharFormat, 6, $iColor)
    Return _SendMessage($hWnd, $EM_SETCHARFORMAT, $SCF_SELECTION, DllStructGetPtr($tCharFormat)) <> 0
EndFunc ;==>_GUICtrlRichEdit_SetCharColor_No_Selection