Func page_static_selector2x2($sPage, $sPluginPath, $sPluginFilename, $iData)
	; draw the banner
	If GUICtrlGetState($aPageCtrl[$iData][1]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][1], $GUI_SHOW)
	Else
		Local $sBanner = IniRead($sPage, "static", "banner", "0")
		$aPageCtrl[$iData][1] = GUICtrlCreatePic("", $aTTWinMainCurrentSize[0]-700, 0, 700, 64)
		If FileExists(@ScriptDir & '\' & $sPluginPath & '\' & $sBanner) Then
			;[TODO] Custom banner graphic
		Else
			_ResourceSetImageToCtrl($aPageCtrl[$iData][1], "BANNER", $RT_RCDATA, $sResources)
		EndIf
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKRIGHT)
	EndIf
	; draw the banner "filler".
	If GUICtrlGetState($aPageCtrl[$iData][2]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][2], $GUI_SHOW)
	Else
		Local $sBannerFill = IniRead($sPage, "static", "bannerfill", "0x3f4e67")
		$aPageCtrl[$iData][2] = GUICtrlCreateLabel("", 0, 0, $aTTWinMainCurrentSize[0]-699, 64)
		GUICtrlSetBkColor(-1, $sBannerFill)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
	EndIf
	; draw title.
	If GUICtrlGetState($aPageCtrl[$iData][3]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][3], $GUI_SHOW)
	Else
		Local $sPageTitle = IniRead($sPage, "static", "titletext", "Untitled")
		$aPageCtrl[$iData][3] = GUICtrlCreateLabel($sPageTitle, 20, 10, $aTTWinMainCurrentSize[0]-20, 24)
		GUICtrlSetFont(-1, 16, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		Local $sPageTitleColor = IniRead($sPage, "static", "titletextcolor", "0xeeeeee")
		GUICtrlSetColor (-1, $sPageTitleColor)
	EndIf
	; draw subtitle
	If GUICtrlGetState($aPageCtrl[$iData][4]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][4], $GUI_SHOW)
	Else
		Local $sPageTitle = IniRead($sPage, "static", "subtitletext", "Subtitle")
		$aPageCtrl[$iData][4] = GUICtrlCreateLabel($sPageTitle, 40, 34, $aTTWinMainCurrentSize[0]-80, 28)
		GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		Local $sPageTitleColor = IniRead($sPage, "static", "subtitletextcolor", "0xeeeeee")
		GUICtrlSetColor (-1, $sPageTitleColor)
	EndIf
	; first button (at 1x1)
	If GUICtrlGetState($aPageCtrl[$iData][5]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][5], $GUI_SHOW)
	Else
		Local $sButton1x1_text = IniRead($sPage, "static", "button1x1_text", "Button1")
		Local $sButton1x1_icon = IniRead($sPage, "static", "button1x1_icon", "0")
		$aPageCtrl[$iData][5] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton1x1_text, $aTTWinMainCurrentSize[0]-570, $aTTWinMainCurrentSize[1]-400, 200, 130, BitOR($BS_CENTER,$BS_MULTILINE))
		;GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton1x1_icon)
	EndIf
	; second button
	If GUICtrlGetState($aPageCtrl[$iData][6]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][6], $GUI_SHOW)
	Else
		Local $sButton1x2_text = IniRead($sPage, "static", "button1x2_text", "Button2")
		Local $sButton1x2_icon = IniRead($sPage, "static", "button1x2_icon", "0")
		$aPageCtrl[$iData][6] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton1x2_text, $aTTWinMainCurrentSize[0]-330, $aTTWinMainCurrentSize[1]-400, 200, 130, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton1x2_icon)
	EndIf
	; third button
	If GUICtrlGetState($aPageCtrl[$iData][7]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][7], $GUI_SHOW)
	Else
		Local $sButton2x1_text = IniRead($sPage, "static", "button2x1_text", "Button3")
		Local $sButton2x1_icon = IniRead($sPage, "static", "button2x1_icon", "0")
		$aPageCtrl[$iData][7] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton2x1_text, $aTTWinMainCurrentSize[0]-570, $aTTWinMainCurrentSize[1]-230, 200, 130, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton2x1_icon)
	EndIf
	; fourth button
	If GUICtrlGetState($aPageCtrl[$iData][8]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][8], $GUI_SHOW)
	Else
		Local $sButton2x2_text = IniRead($sPage, "static", "button2x2_text", "Button4")
		Local $sButton2x2_icon = IniRead($sPage, "static", "button2x2_icon", "0")
		$aPageCtrl[$iData][8] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton2x2_text, $aTTWinMainCurrentSize[0]-330, $aTTWinMainCurrentSize[1]-230, 200, 130, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton2x2_icon)
	EndIf
EndFunc



#comments-start

	$APSPage[5] = GUICtrlCreateButton(@CR & @CR & @CR & "Customize an Android Kernel", $APSWinMainCurrentSize[0]-330, $APSWinMainCurrentSize[1]-400, 200, 130, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetOnEvent(-1, "APSTaskSelection")
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, 11)
	$APSPage[6] = GUICtrlCreateButton(@CR & @CR & @CR & "Debugging and Diagnostics", $APSWinMainCurrentSize[0]-570, $APSWinMainCurrentSize[1]-230, 200, 130, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetOnEvent(-1, "APSTaskSelection")
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, 12)
	$APSPage[7] = GUICtrlCreateButton(@CR & @CR & @CR & "Who knows?", $APSWinMainCurrentSize[0]-330, $APSWinMainCurrentSize[1]-230, 200, 130, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetOnEvent(-1, "APSTaskSelection")
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, 13)
EndFunc

Func APSTaskSelection()
	Switch @GUI_CtrlId
		Case $APSPage[4]
			DrawPage(1)
		Case $APSPage[5]
			DrawPage(-250)
		Case $APSPage[6]
			DrawPage(-500)
	EndSwitch
EndFunc

#comments-end