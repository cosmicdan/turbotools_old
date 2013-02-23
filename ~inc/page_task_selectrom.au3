Func page_task_selectrom($sPluginPath, $sPluginFilename)
	; draw the banner
	If GUICtrlGetState($aPageCtrl[$iPageIndex][1]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][1], $GUI_SHOW)
	Else
		Local $sBanner = IniRead($sPage, "task", "banner", "0")
		$aPageCtrl[$iPageIndex][1] = GUICtrlCreatePic("", $aTTWinMainCurrentSize[0]-700, 0, 700, 64)
		If FileExists(@ScriptDir & '\' & $sPluginPath & '\' & $sBanner) Then
			;[TODO] Custom banner graphic
		Else
			_ResourceSetImageToCtrl($aPageCtrl[$iPageIndex][1], "BANNER", $RT_RCDATA, $sResources)
		EndIf
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKRIGHT)
	EndIf
	; draw the banner "filler".
	If GUICtrlGetState($aPageCtrl[$iPageIndex][2]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][2], $GUI_SHOW)
	Else
		Local $sBannerFill = IniRead($sPage, "task", "bannerfill", "0x3f4e67")
		$aPageCtrl[$iPageIndex][2] = GUICtrlCreateLabel("", 0, 0, $aTTWinMainCurrentSize[0]-699, 64)
		GUICtrlSetBkColor(-1, $sBannerFill)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
	EndIf
	; draw title.
	If GUICtrlGetState($aPageCtrl[$iPageIndex][3]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][3], $GUI_SHOW)
	Else
		Local $sPageTitle = IniRead($sPage, "task", "titletext", "Untitled")
		$aPageCtrl[$iPageIndex][3] = GUICtrlCreateLabel($sPageTitle, 20, 10, $aTTWinMainCurrentSize[0]-20, 24)
		GUICtrlSetFont(-1, 16, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		Local $sPageTitleColor = IniRead($sPage, "static", "titletextcolor", "0xeeeeee")
		GUICtrlSetColor (-1, $sPageTitleColor)
	EndIf
	; draw subtitle
	If GUICtrlGetState($aPageCtrl[$iPageIndex][4]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][4], $GUI_SHOW)
	Else
		Local $sPageTitle = IniRead($sPage, "task", "subtitletext", "Subtitle")
		$aPageCtrl[$iPageIndex][4] = GUICtrlCreateLabel($sPageTitle, 40, 34, $aTTWinMainCurrentSize[0]-80, 28)
		GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		Local $sPageTitleColor = IniRead($sPage, "task", "subtitletextcolor", "0xeeeeee")
		GUICtrlSetColor (-1, $sPageTitleColor)
	EndIf


	If GUICtrlGetState($aPageCtrl[$iPageIndex][5]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][5], $GUI_SHOW)
	Else
		Local $sHeadText = IniRead($sPage, "task", "headtext", "Select a ROM in either an update ZIP package or an existing folder on your PC.")
		$sHeadText = StringReplace($sHeadText, "|n|", @CRLF)
		$aPageCtrl[$iPageIndex][5] = GUICtrlCreateLabel($sHeadText, 20, 90, $aTTWinMainCurrentSize[0]-40, 80, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 9, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	EndIf
	If GUICtrlGetState($aPageCtrl[$iPageIndex][6]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][6], $GUI_SHOW)
	Else
		$aPageCtrl[$iPageIndex][6] = GUICtrlCreateGroup("ROM Type", 20, 180, 140, 80)
		GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKTOP)
	EndIf
	If GUICtrlGetState($aPageCtrl[$iPageIndex][7]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][7], $GUI_SHOW)
	Else
		$aPageCtrl[$iPageIndex][7] = GUICtrlCreateRadio("Directory", 40, 200, 105, 20)
		GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKTOP)
		GUICtrlSetOnEvent(-1, "page_task_selectrom_action")
	EndIf
	If GUICtrlGetState($aPageCtrl[$iPageIndex][8]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][8], $GUI_SHOW)
	Else
		$aPageCtrl[$iPageIndex][8] = GUICtrlCreateRadio("ZIP Package", 40, 230, 105, 20)
		GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKLEFT + $GUI_DOCKTOP)
		GUICtrlSetOnEvent(-1, "page_task_selectrom_action")
	EndIf
	;close group
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	If GUICtrlGetState($aPageCtrl[$iPageIndex][9]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][9], $GUI_SHOW)
	Else
		$aPageCtrl[$iPageIndex][9] = GUICtrlCreateInput("", 185, 200, $aTTWinMainCurrentSize[0]*0.70, 20)
		GUICtrlSetOnEvent(-1, "page_task_selectrom_action")
	EndIf

	If GUICtrlGetState($aPageCtrl[$iPageIndex][10]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][10], $GUI_SHOW)
	Else
		$aPageCtrl[$iPageIndex][10] = GUICtrlCreateButton ("Browse...", $aTTWinMainCurrentSize[0]-104, 228, 80, 24)
		GUICtrlSetOnEvent(-1, "page_task_selectrom_action")
		GUICtrlSetResizing(-1, $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT + $GUI_DOCKRIGHT + $GUI_DOCKTOP)
	EndIf

	;progress stuff
	If GUICtrlGetState($aPageCtrl[$iPageIndex][11]) <= 0 Then
		$aPageCtrl[$iPageIndex][11] = GUICtrlCreateProgress(300, 360, $aTTWinMainCurrentSize[0]-600, 10, $PBS_MARQUEE)
		GUICtrlSendMsg(-1, $PBM_SETMARQUEE, True, 30)
		GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM + $GUI_DOCKVCENTER + $GUI_DOCKHEIGHT)
	EndIf
	If GUICtrlGetState($aPageCtrl[$iPageIndex][12]) <= 0 Then
		$aPageCtrl[$iPageIndex][12] = GUICtrlCreateLabel("", 20, 380, $aTTWinMainCurrentSize[0]-40, 20, $SS_CENTER)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
		GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
	EndIf

	;set defaults
	GUICtrlSetState( $aPageCtrl[$iPageIndex][7], $GUI_CHECKED )
	GUICtrlSendMsg($aPageCtrl[$iPageIndex][9], 0x1501, 0, "Select Directory...")  ; Editbox "tooltip"

	;hide progress stuff
	GUICtrlSetState($aPageCtrl[$iPageIndex][11], $GUI_HIDE)
	GUICtrlSetState($aPageCtrl[$iPageIndex][12], $GUI_HIDE)

EndFunc

Func page_task_selectrom_action()
	Switch @GUI_CtrlId
		Case $aPageCtrl[$iPageIndex][7]  ; 'Directory' radio
			GUICtrlSendMsg($aPageCtrl[$iPageIndex][9], 0x1501, 0, "Select Directory...")
			GUICtrlSetData($aPageCtrl[$iPageIndex][9], "")
		Case $aPageCtrl[$iPageIndex][8]  ; 'ZIP Package' radio
			GUICtrlSendMsg($aPageCtrl[$iPageIndex][9], 0x1501, 0, "Select ZIP Package...")
			GUICtrlSetData($aPageCtrl[$iPageIndex][9], "")
		Case $aPageCtrl[$iPageIndex][9]  ; InputBox
			page_task_selectrom_verify()
		Case $aPageCtrl[$iPageIndex][10] ; 'Browse' button
			If BitAND(GUICtrlRead($aPageCtrl[$iPageIndex][7]), $GUI_CHECKED) Then
				; browse for folder
				GUICtrlSetData($aPageCtrl[$iPageIndex][9], FileSelectFolder("Select Directory", "", "6"))
				page_task_selectrom_verify()
			Else
				; browse for ZIP
				GUICtrlSetData($aPageCtrl[$iPageIndex][9], FileOpenDialog("Select ZIP Package", "", "Update ZIP Packages (*.zip)", "3"))
				page_task_selectrom_verify()
			EndIf
	EndSwitch
EndFunc

Func page_task_selectrom_verify()
	Local $sVerifyText = IniRead($sPage, "task", "footertextverify", "Verifying...")
	Local $sVerifyOK = IniRead($sPage, "task", "footertextverifyok", "Valid")
	Local $sVerifyBad = IniRead($sPage, "task", "footertextverifybad", "Invalid")
	GuiCtrlSetData($aPageCtrl[$iPageIndex][12], $sVerifyText)
	GUICtrlSetState($aPageCtrl[$iPageIndex][11], $GUI_SHOW)
	GUICtrlSetState($aPageCtrl[$iPageIndex][12], $GUI_SHOW)
	If BitAND(GUICtrlRead($aPageCtrl[$iPageIndex][7]), $GUI_CHECKED) Then
		;verify folder
		echo ("Verify folder...")
	Else
		;verify zip
		echo ("Verify ZIP...")
	EndIf
	;GUICtrlSetState($aPageCtrl[$iPageIndex][11], $GUI_HIDE)
	;GUICtrlSetState($aPageCtrl[$iPageIndex][12], $GUI_HIDE)
EndFunc
