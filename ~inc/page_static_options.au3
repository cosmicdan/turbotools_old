Func page_static_options($sPluginPath, $sPluginFilename)
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
        $aPageCtrl[$iPageIndex][4] = GUICtrlCreateLabel("Options", 20, 3, $aTTWinMainCurrentSize[0]-20, 24)
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
        $aPageCtrl[$iPageIndex][5] = GUICtrlCreateLabel("Settings for Turbo Tools and Plugins" , 40, 28, $aTTWinMainCurrentSize[0]-80, 28)
        GUICtrlSetFont(-1, 10, 500, Default, "Trebuchet MS", 5)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
        GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
        Local $sPageTitleColor = _IniRead($sPage, "static", "subtitletextcolor", "0xeeeeee")
        If @error Then Return 0
        GUICtrlSetColor (-1, $sPageTitleColor)
    EndIf

    ; Change background color to suit hard-coded BTNFACE used in tab controls
    GUISetBkColor (_WinAPI_GetSysColor($COLOR_BTNFACE), $hTTWinMain)

    ; Tab control, it's a "container" for the tabs
    If GUICtrlGetState($aPageCtrl[$iPageIndex][6]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][6], $GUI_SHOW)
    Else
        $aPageCtrl[$iPageIndex][6] = GUICtrlCreateTab(20, 60, $aTTWinMainCurrentSize[0]-40, $aTTWinMainCurrentSize[1]-120, $TCS_MULTILINE)
        GUICtrlSetResizing(-1, $GUI_DOCKBORDERS)
        ; Create the tabs. These don't need a handle.
        GUICtrlCreateTabItem ("Core")
        DoTabControls("core")
        ; [TODO] Create tabs for plugins, far future
        ;Finished creating tabs
        GUICtrlCreateTabItem("")
    EndIf
EndFunc

Func DoTabControls($sPlugin)
    GUICtrlSetDefBkColor ($sTabCtrlBk, $hTTWinMain)
    If $sPlugin = "core" Then
        ; vertical seperator
        If GUICtrlGetState($aPageCtrl[$iPageIndex][7]) > 0 Then
            GUICtrlSetState($aPageCtrl[$iPageIndex][7], $GUI_SHOW)
        Else
            $aPageCtrl[$iPageIndex][7] = GUICtrlCreateLabel("", $aTTWinMainCurrentSize[0]/2-1, 100, 2, 320)
            GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKWIDTH + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
            GUICtrlSetBkColor(-1, 0xdddddd)
        EndIf
        If GUICtrlGetState($aPageCtrl[$iPageIndex][8]) > 0 Then
            GUICtrlSetState($aPageCtrl[$iPageIndex][8], $GUI_SHOW)
        Else
            $aPageCtrl[$iPageIndex][8] = GUICtrlCreateGroup("Temporary Folder", 40, 100, $aTTWinMainCurrentSize[0]/2-60, $aTTWinMainCurrentSize[1]*0.16)
            GUICtrlSetResizing(-1, $GUI_DOCKALL)
        EndIf
        If GUICtrlGetState($aPageCtrl[$iPageIndex][9]) > 0 Then
            GUICtrlSetState($aPageCtrl[$iPageIndex][9], $GUI_SHOW)
        Else
            $aPageCtrl[$iPageIndex][9] = GUICtrlCreateRadio("User Temp (" & @TempDir & ")", 50, 115, $aTTWinMainCurrentSize[0]/2-80, $aTTWinMainCurrentSize[1]*0.05)
            GUICtrlSetResizing(-1, $GUI_DOCKALL)
            ;GUICtrlSetOnEvent(-1, "page_options_tempfolder_action")
        EndIf
        If GUICtrlGetState($aPageCtrl[$iPageIndex][10]) > 0 Then
            GUICtrlSetState($aPageCtrl[$iPageIndex][10], $GUI_SHOW)
        Else
            $aPageCtrl[$iPageIndex][10] = GUICtrlCreateRadio("Custom", 50, 145, $aTTWinMainCurrentSize[0]/2-80, $aTTWinMainCurrentSize[1]*0.05)
            GUICtrlSetResizing(-1, $GUI_DOCKALL)
            ;GUICtrlSetOnEvent(-1, "page_options_tempfolder_action")
        EndIf
        ;close group
        GUICtrlCreateGroup("", -99, -99, 1, 1)
        GUICtrlSetDefBkColor ($GUI_BKCOLOR_TRANSPARENT, $hTTWinMain)
        ;populate current options
        DoOptionsPopulate()
    EndIf
EndFunc

Func OptionsRestoreButtonrow()
    ; reset original icon - Next
    ButtonIcon($hTTBtn[5], 9)
    ; reset original icon and text - Quit
    ButtonIcon($hTTBtn[6], 11)
    GUICtrlSetData($hTTBtn[6], "Quit")
EndFunc

Func DoOptionsPopulate()
    ;temp folder
    If $sTempDir = @TempDir Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][9], $GUI_CHECKED)
    Else
        GUICtrlSetState($aPageCtrl[$iPageIndex][10], $GUI_CHECKED)
    EndIf
EndFunc

Func _WM_SIZE___core_page_options($hWnd, $iMsg, $wParam, $lParam)
    GUICtrlSetPos($aPageCtrl[$iPageIndex][8], Default, Default, $aTTWinMainCurrentSize[0]/2-60, $aTTWinMainCurrentSize[1]*0.16)
    GUICtrlSetPos($aPageCtrl[$iPageIndex][9], Default, Default, $aTTWinMainCurrentSize[0]/2-80, $aTTWinMainCurrentSize[1]*0.05)
    GUICtrlSetPos($aPageCtrl[$iPageIndex][10], Default, Default, $aTTWinMainCurrentSize[0]/2-80, $aTTWinMainCurrentSize[1]*0.05)
EndFunc