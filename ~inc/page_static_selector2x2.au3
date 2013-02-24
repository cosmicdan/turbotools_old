Func page_static_selector2x2($sPluginPath, $sPluginFilename)
	; draw the banner
	If GUICtrlGetState($aPageCtrl[$iPageIndex][1]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][1], $GUI_SHOW)
	Else
		Local $sBanner = IniRead($sPage, "static", "banner", "0")
		$aPageCtrl[$iPageIndex][1] = GUICtrlCreatePic("", $aTTWinMainCurrentSize[0]-525, 0, 525, 48)
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
		Local $sBannerFill = IniRead($sPage, "static", "bannerfill", "0x3f4e67")
		$aPageCtrl[$iPageIndex][2] = GUICtrlCreateLabel("", 0, 0, $aTTWinMainCurrentSize[0]-525, 48)
		GUICtrlSetBkColor(-1, $sBannerFill)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
	EndIf
	; draw the banner icon.
	If GUICtrlGetState($aPageCtrl[$iPageIndex][3]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][3], $GUI_SHOW)
	Else
		Local $sBannerIcon = IniRead($sPage, "static", "bannericon", "0")
		If FileExists(@ScriptDir & '\' & $sPluginPath & '\' & $sBannerIcon) Then
			;[TODO] Custom icon code
		Else
			$aPageCtrl[$iPageIndex][3] = GUICtrlCreatePic('', $aTTWinMainCurrentSize[0]-42, 8, 32, 32)
			GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
			Local $hIcon = _Icons_Icon_Extract($sResources, $sBannerIcon, 32, 32)
			Local $hBitmap = _Icons_Bitmap_CreateFromIcon($hIcon)
			_SetHImage($aPageCtrl[$iPageIndex][3], $hBitmap)
			_WinAPI_DeleteObject($hBitmap)
            _WinAPI_DestroyIcon($hIcon)
		EndIf
	EndIf
	; draw title.
	If GUICtrlGetState($aPageCtrl[$iPageIndex][4]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][4], $GUI_SHOW)
	Else
		Local $sPageTitle = IniRead($sPage, "static", "titletext", "Untitled")
		$aPageCtrl[$iPageIndex][4] = GUICtrlCreateLabel($sPageTitle, 20, 3, $aTTWinMainCurrentSize[0]-20, 24)
		GUICtrlSetFont(-1, 16, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		Local $sPageTitleColor = IniRead($sPage, "static", "titletextcolor", "0xeeeeee")
		GUICtrlSetColor (-1, $sPageTitleColor)
	EndIf
	; draw subtitle
	If GUICtrlGetState($aPageCtrl[$iPageIndex][5]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][5], $GUI_SHOW)
	Else
		Local $sPageTitle = IniRead($sPage, "static", "subtitletext", "Subtitle")
		$aPageCtrl[$iPageIndex][5] = GUICtrlCreateLabel($sPageTitle, 40, 28, $aTTWinMainCurrentSize[0]-80, 28)
		GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		Local $sPageTitleColor = IniRead($sPage, "static", "subtitletextcolor", "0xeeeeee")
		GUICtrlSetColor (-1, $sPageTitleColor)
	EndIf
	; first button (at 1x1)
	If GUICtrlGetState($aPageCtrl[$iPageIndex][6]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][6], $GUI_SHOW)
	Else
		Local $sButton1x1_text = IniRead($sPage, "static", "button1x1_text", "Button1")
		Local $sButton1x1_icon = IniRead($sPage, "static", "button1x1_icon", "0")
		$aPageCtrl[$iPageIndex][6] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton1x1_text, $aTTWinMainCurrentSize[0]*0.20, $aTTWinMainCurrentSize[1]*0.20, $aTTWinMainCurrentSize[0]*0.29, $aTTWinMainCurrentSize[1]*0.29, BitOR($BS_CENTER,$BS_MULTILINE))
		;GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton1x1_icon)
		GUICtrlSetOnEvent(-1, "page_static_selector2x2_action")
	EndIf
	; second button
	If GUICtrlGetState($aPageCtrl[$iPageIndex][7]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][7], $GUI_SHOW)
	Else
		Local $sButton1x2_text = IniRead($sPage, "static", "button1x2_text", "Button2")
		Local $sButton1x2_icon = IniRead($sPage, "static", "button1x2_icon", "0")
		$aPageCtrl[$iPageIndex][7] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton1x2_text, $aTTWinMainCurrentSize[0]*0.50, $aTTWinMainCurrentSize[1]*0.20, $aTTWinMainCurrentSize[0]*0.29, $aTTWinMainCurrentSize[1]*0.29, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton1x2_icon)
		GUICtrlSetOnEvent(-1, "page_static_selector2x2_action")
	EndIf
	; third button
	If GUICtrlGetState($aPageCtrl[$iPageIndex][8]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][8], $GUI_SHOW)
	Else
		Local $sButton2x1_text = IniRead($sPage, "static", "button2x1_text", "Button3")
		Local $sButton2x1_icon = IniRead($sPage, "static", "button2x1_icon", "0")
		$aPageCtrl[$iPageIndex][8] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton2x1_text, $aTTWinMainCurrentSize[0]*0.20, $aTTWinMainCurrentSize[1]*0.50, $aTTWinMainCurrentSize[0]*0.29, $aTTWinMainCurrentSize[1]*0.29, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton2x1_icon)
		GUICtrlSetOnEvent(-1, "page_static_selector2x2_action")
	EndIf
	; fourth button
	If GUICtrlGetState($aPageCtrl[$iPageIndex][9]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][9], $GUI_SHOW)
	Else
		Local $sButton2x2_text = IniRead($sPage, "static", "button2x2_text", "Button4")
		Local $sButton2x2_icon = IniRead($sPage, "static", "button2x2_icon", "0")
		$aPageCtrl[$iPageIndex][9] = GUICtrlCreateButton(@CR & @CR & @CR & @CR & $sButton2x2_text, $aTTWinMainCurrentSize[0]*0.50, $aTTWinMainCurrentSize[1]*0.50, $aTTWinMainCurrentSize[0]*0.29, $aTTWinMainCurrentSize[1]*0.29, BitOR($BS_CENTER,$BS_MULTILINE))
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		ButtonIcon32(-1, $sButton2x2_icon)
		GUICtrlSetOnEvent(-1, "page_static_selector2x2_action")
	EndIf
EndFunc

Func page_static_selector2x2_action()
	Switch @GUI_CtrlId
		Case $aPageCtrl[$iPageIndex][6] ; first button
			Local $sButton_type = IniRead($sPage, "static", "button1x1_type", "page")
			Local $sButton_data = IniRead($sPage, "static", "button1x1_data", "0")
		Case $aPageCtrl[$iPageIndex][7] ; second button
			Local $sButton_type = IniRead($sPage, "static", "button1x2_type", "page")
			Local $sButton_data = IniRead($sPage, "static", "button1x2_data", "0")
		Case $aPageCtrl[$iPageIndex][8] ; third button
			Local $sButton_type = IniRead($sPage, "static", "button2x1_type", "page")
			Local $sButton_data = IniRead($sPage, "static", "button2x1_data", "0")
		Case $aPageCtrl[$iPageIndex][9] ; fourth button
			Local $sButton_type = IniRead($sPage, "static", "button2x2_type", "page")
			Local $sButton_data = IniRead($sPage, "static", "button2x2_data", "0")
	EndSwitch
	Call("page_static_selector2x2_action_" & $sButton_type, $sButton_data)
EndFunc

Func page_static_selector2x2_action_page($sData)
	Local $aData=StringSplit($sData, "|")
	If Not $aData[0]="2" Then
		; error - bad data
	Else
		$sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
		DrawPage($aData[1], $aData[2])
	EndIf
EndFunc
