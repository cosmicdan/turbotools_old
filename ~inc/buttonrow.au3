Global $hTTBtn[7] ; Maximum of six bottom-bar buttons (1 is the divider)

Func DoButtonBar()
	RemoveButtons()
	$hTTBtn[0] = GUICtrlCreateLabel("", 20, 457, 660, 1, $SS_SUNKEN) ; Divider above buttons
		;GUICtrlSetBkColor(-1, 0x777777)
		GUICtrlSetResizing(-1, $GUI_DOCKSTATEBAR)
	; Always do quit button (change to cancel later if needed)
	$hTTBtn[6] = GUICtrlCreateButton("Quit", 600, 464, 92, 30)
		GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
		GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
		ButtonIcon(-1, 11)
EndFunc

Func DoButtonRow($key, $value, $sPluginIni)
    Select
		Case ($key = "options")
			If $value = "1" Then
				$hTTBtn[1] = GUICtrlCreateButton("Options...", 8, 464, 92, 30) ; First button (bottom-left corner)
				GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
				GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKLEFT)
				ButtonIcon(-1, 12)
			EndIf
		Case ($key = "about")
			If $value = "1" Then
				$hTTBtn[2] = GUICtrlCreateButton("About...", 104, 464, 92, 30) ; Second button (just right of first button)
				GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
				GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKLEFT)
				ButtonIcon(-1, 4)
			EndIf
		Case ($key = "custom")
			$bButtonRow_CustomTask = False
			If Not $value = "1" Then
				$hTTBtn[3] = GUICtrlCreateButton("Advanced...", 274, 464, 100, 30) ; Third button (first in the right-aligned corner)
				GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
				GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
				ButtonIcon(-1, 12)
				$bButtonRow_CustomTask = True
			EndIf
		Case ($key = "back")
			If $value = "1" Then
				$hTTBtn[4] = GUICtrlCreateButton("Back", 396, 464, 92, 30)
				GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
				GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
				ButtonIcon(-1, 8)
			EndIf
		Case ($key = "next")
			If $value = "1" Then
				$hTTBtn[5] = GUICtrlCreateButton("Next", 490, 464, 92, 30)
				GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
				GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
				ButtonIcon(-1, 9)
			EndIf
		; Set button configurations/flags
		Case ($key = "customtask")
		    If $bButtonRow_CustomTask = True Then
				echo ("[!] Key 'customtask' is enabled but not yet implemented");
			EndIf
		Case ($key = "backpage")
			If Not $value = "0" Then
				echo ("[!] Key 'backpage' is specified but not yet implemented");
			EndIf
		Case ($key = "nextpage")
			If Not $value = "0" Then
				echo ("[!] Key 'nextpage' is specified but not yet implemented");
			EndIf
		Case $key = "nexttext"
			GUICtrlSetData($hTTBtn[5], $value)
		Case $key = "quit"
			If $value = "cancel" Then
				echo ("[!] Key/value 'quit=cancel' is specified but not yet implemented");
			EndIf
		Case Else
			_ExtMsgBox($sResources, 0, "Warning", 'Warning in ' & $sPluginIni & @CRLF & _
					'At section [buttonrow]' & @CRLF & _
					'Key not recognized: "' & $key & '"', _
					0, $hTTWinMain, 0, -8)
	EndSelect

EndFunc

Func RemoveButtons()
	Local $NumberOfControls = UBound($hTTBtn)
	For $i = 0 to $NumberOfControls  - 1 ; delete buttons
		GUICtrlDelete($hTTBtn[$i])
	Next
EndFunc
