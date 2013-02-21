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

Func DoButtonRow($key, $value)
    Select
		Case ($key = "options" And $value = "1")
			$hTTBtn[1] = GUICtrlCreateButton("Options...", 8, 464, 92, 30) ; First button (bottom-left corner)
			GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
			GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKLEFT)
			ButtonIcon(-1, 12)
		Case ($key = "about" And $value = "1")
			$hTTBtn[2] = GUICtrlCreateButton("About...", 104, 464, 92, 30) ; Second button (just right of first button)
			GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
			GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKLEFT)
			ButtonIcon(-1, 4)
		Case ($key = "custom" And $value = "1")
			$hTTBtn[3] = GUICtrlCreateButton("Advanced...", 274, 464, 100, 30) ; Third button (first in the right-aligned corner)
			GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
			GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
			ButtonIcon(-1, 12)
			$bButtonRow_CustomTask = True
		Case ($key = "back" And $value = "1")
			$hTTBtn[4] = GUICtrlCreateButton("Back", 396, 464, 92, 30)
			GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
			GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
			ButtonIcon(-1, 8)
		Case ($key = "next" And $value = "1")
			$hTTBtn[5] = GUICtrlCreateButton("Next", 490, 464, 92, 30)
			GUICtrlSetOnEvent(-1, "TTWinMainButtonEvent")
			GUICtrlSetResizing(-1, $GUI_DOCKSIZE + $GUI_DOCKRIGHT)
			ButtonIcon(-1, 9)
		; Set button configurations/flags
		Case ($key = "customtask" And $bButtonRow_CustomTask = True)
			echo ("[!] Key 'customtask' is enabled but not yet implemented");
		Case ($key = "backpage" And Not $value = "0")
			echo ("[!] Key 'backpage' is specified but not yet implemented");
		Case ($key = "nextpage" And Not $value = "0")
			echo ("[!] Key 'nextpage' is specified but not yet implemented");
		Case $key = "nexttext"
			GUICtrlSetData($hTTBtn[5], $value)
		;Case Else
			; error unknown key
	EndSelect

EndFunc

Func RemoveButtons()
	Local $NumberOfControls = UBound($hTTBtn)
	For $i = 0 to $NumberOfControls  - 1 ; delete buttons
		GUICtrlDelete($hTTBtn[$i])
	Next
EndFunc
