Global $hTTBtn[7] ; Maximum of six bottom-bar buttons (1 is the divider)

Func DoButtonBar()
	$hTTBtn[0] = GUICtrlCreateLabel("", 20, 457, 660, 1, $SS_SUNKEN) ; Divider above buttons
		GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
	$hTTBtn[1] = GUICtrlCreateButton("Options...", 8, 464, 92, 30) ; First button (bottom-left corner)
		GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKLEFT)
		ButtonIcon(-1, 12)
	$hTTBtn[2] = GUICtrlCreateButton("About...", 104, 464, 92, 30) ; Second button (just right of first button)
		GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKLEFT)
		ButtonIcon(-1, 4)
	$hTTBtn[3] = GUICtrlCreateButton("Advanced...", 274, 464, 100, 30) ; Third button (first in the right-aligned corner)
		GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
		ButtonIcon(-1, 12)
	$hTTBtn[4] = GUICtrlCreateButton("Back", 396, 464, 92, 30)
		GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
		ButtonIcon(-1, 8)
	$hTTBtn[5] = GUICtrlCreateButton("Next", 490, 464, 92, 30)
		GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
		ButtonIcon(-1, 9)
	$hTTBtn[6] = GUICtrlCreateButton("Quit", 600, 464, 92, 30)
		GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
		ButtonIcon(-1, 11)
EndFunc

Func DoButtonRow($key, $value, $sPluginIni)
    Select
		Case ($key = "options")
			If $value = "1" Then
				GUICtrlSetState($hTTBtn[1], $GUI_SHOW)
			EndIf
		Case ($key = "about")
			If $value = "1" Then
				GUICtrlSetState($hTTBtn[2], $GUI_SHOW)
			EndIf
		Case ($key = "custom")
			$bButtonRow_CustomTask = False
			If $value = "1" Then
				GUICtrlSetState($hTTBtn[3], $GUI_SHOW)
				$bButtonRow_CustomTask = True
			EndIf
		Case ($key = "back")
			If $value = "1" Then
				GUICtrlSetState($hTTBtn[4], $GUI_SHOW)
			EndIf
		Case ($key = "next")
			GUICtrlSetData($hTTBtn[5], "Next")
			If $value = "1" Then
				GUICtrlSetState($hTTBtn[5], $GUI_SHOW)
				GUICtrlSetState($hTTBtn[5], $GUI_ENABLE)
			ElseIf $value = "disabled" Then
				GUICtrlSetState($hTTBtn[5], $GUI_SHOW)
				GUICtrlSetState($hTTBtn[5], $GUI_DISABLE)
			EndIf
		; Set button configurations/flags
		Case ($key = "customtask")
		    If $bButtonRow_CustomTask = True Then
				If $value = "debugpane" Then
					GUICtrlSetData($hTTBtn[3], "Debug...")
					GUICtrlSetData($hTTBtn[6], "Bail Out")
					$bCfgQuickQuit = 1
				EndIf
			EndIf
		Case ($key = "backpage")
			If Not $value = "0" Then
				echo ("    [i] 'Back' is mapped to " & $value);
			EndIf
		Case ($key = "nextpage")
			If Not $value = "0" Then
				echo ("    [i] 'Next' is mapped to " & $value);
			EndIf
		Case $key = "nexttext"
			GUICtrlSetData($hTTBtn[5], $value)
		Case $key = "quit"
			If $value = "cancel" Then
				echo ("    [!] Key/value 'quit=cancel' is specified but not yet implemented");
			EndIf
		Case Else
			_ExtMsgBox($sResources, 0, "Warning", 'Warning in ' & $sPluginIni & @CRLF & _
					'At section [buttonrow]' & @CRLF & _
					'Key not recognized: "' & $key & '"', _
					0, $hTTWinMain, 0, -8)
	EndSelect
	; Always show quit/cancel button
	GUICtrlSetState($hTTBtn[6], $GUI_SHOW)
EndFunc

Func HideButtons()
	Local $NumberOfControls = UBound($hTTBtn) - 1
	For $i = 1 to $NumberOfControls ;start at 1 since 0 is the divider
		GUICtrlSetState($hTTBtn[$i], $GUI_HIDE)
	Next
EndFunc
