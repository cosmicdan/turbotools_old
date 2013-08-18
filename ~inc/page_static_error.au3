Func page_static_error($sPluginPath, $sPluginFilename)
    ; draw the banner
    If GUICtrlGetState($aPageCtrl[$iPageIndex][1]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][1], $GUI_SHOW)
    Else
        Local $sBanner = _IniRead($sPage, "static", "banner", 0)
        If @error Then Return 0
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
        Local $sBannerFill = _IniRead($sPage, "static", "bannerfill", "0x3f4e67")
        If @error Then Return 0
        $aPageCtrl[$iPageIndex][2] = GUICtrlCreateLabel("", 0, 0, $aTTWinMainCurrentSize[0]-525, 48)
        GUICtrlSetBkColor(-1, $sBannerFill)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
    EndIf
    ; draw the banner icon.
    If GUICtrlGetState($aPageCtrl[$iPageIndex][3]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][3], $GUI_SHOW)
    Else
        Local $sBannerIcon = _IniRead($sPage, "static", "bannericon", 0)
        If @error Then Return 0
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
        $aPageCtrl[$iPageIndex][4] = GUICtrlCreateLabel("Error", 20, 3, $aTTWinMainCurrentSize[0]-20, 24)
        GUICtrlSetFont(-1, 16, 500, Default, "Trebuchet MS", 5)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
        Local $sPageTitleColor = _IniRead($sPage, "static", "titletextcolor", "0xeeeeee")
        If @error Then Return 0
        GUICtrlSetColor (-1, $sPageTitleColor)
    EndIf
    ; draw subtitle
    If GUICtrlGetState($aPageCtrl[$iPageIndex][5]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][5], $GUI_SHOW)
    Else
        $aPageCtrl[$iPageIndex][5] = GUICtrlCreateLabel("Requested page not found" , 40, 28, $aTTWinMainCurrentSize[0]-80, 28)
        GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
        Local $sPageTitleColor = _IniRead($sPage, "static", "subtitletextcolor", "0xeeeeee")
        If @error Then Return 0
        GUICtrlSetColor (-1, $sPageTitleColor)
    EndIf

    ; "Crashed" text
    If GUICtrlGetState($aPageCtrl[$iPageIndex][6]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][6], $GUI_SHOW)
    Else
        $aPageCtrl[$iPageIndex][6] = GUICtrlCreateLabel("Turbo Tools has crashed. Reason:" , 30, 100, $aTTWinMainCurrentSize[0]-60, 30)
        GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    EndIf
    ; "Reason" text, provided by $sExtraData where provided
    If $sExtraData = False Then
        $sExtraData = "No reason was given by the plugin."
    Else
        $sExtraData = StringReplace($sExtraData, "|n|", @CRLF)
    EndIf
    If GUICtrlGetState($aPageCtrl[$iPageIndex][7]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][7], $GUI_SHOW)
        GUICtrlSetData($aPageCtrl[$iPageIndex][7], $sExtraData)
    Else
        $aPageCtrl[$iPageIndex][7] = GUICtrlCreateLabel($sExtraData, 40, 140, $aTTWinMainCurrentSize[0]-80, 80)
        GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    EndIf
    ; It's essential to clear the sExtraData field to prevent it from being reused
    $sExtraData = False
    ; Footer text
    If GUICtrlGetState($aPageCtrl[$iPageIndex][8]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][8], $GUI_SHOW)
    Else
        $aPageCtrl[$iPageIndex][8] = GUICtrlCreateLabel("Press 'Debug' to see technical info, or press 'Bail Out' to quit." , 25, $aTTWinMainCurrentSize[1]-80, $aTTWinMainCurrentSize[0]-50, 30, $SS_RIGHT)
        GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
    EndIf

EndFunc
