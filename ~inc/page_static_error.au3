Func page_static_error($sPluginPath, $sPluginFilename)
	; draw the banner
	If GUICtrlGetState($aPageCtrl[$iPageIndex][1]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][1], $GUI_SHOW)
	Else
		Local $sBanner = IniRead($sPage, "static", "banner", "0")
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
		Local $sBannerFill = IniRead($sPage, "static", "bannerfill", "0x3f4e67")
		$aPageCtrl[$iPageIndex][2] = GUICtrlCreateLabel("", 0, 0, $aTTWinMainCurrentSize[0]-699, 64)
		GUICtrlSetBkColor(-1, $sBannerFill)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
	EndIf
	; draw title.
	If GUICtrlGetState($aPageCtrl[$iPageIndex][3]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][3], $GUI_SHOW)
	Else
		$aPageCtrl[$iPageIndex][3] = GUICtrlCreateLabel("Error", 20, 10, $aTTWinMainCurrentSize[0]-20, 24)
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
		$aPageCtrl[$iPageIndex][4] = GUICtrlCreateLabel("Requested page not found" , 40, 34, $aTTWinMainCurrentSize[0]-80, 28)
		GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		Local $sPageTitleColor = IniRead($sPage, "static", "subtitletextcolor", "0xeeeeee")
		GUICtrlSetColor (-1, $sPageTitleColor)
	EndIf
	If GUICtrlGetState($aPageCtrl[$iPageIndex][5]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iPageIndex][5], $GUI_SHOW)
	Else
		$aPageCtrl[$iPageIndex][5] = GUICtrlCreateLabel("Turbo Tools has crashed. Press 'Debug' to dump current data index, or Bail Out to close." , 30, 100, $aTTWinMainCurrentSize[0]-80, 28)
		GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	EndIf
EndFunc
