Func page_static_welcome($sPluginPath, $sPluginFilename)
    ; draw the banner
    If GUICtrlGetState($aPageCtrl[$iPageIndex][1]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][1], $GUI_SHOW)
    Else
        Local $sBanner = IniRead($sPage, "static", "banner", "0")
        $aPageCtrl[$iPageIndex][1] = GUICtrlCreatePic("", 0, 0, 180, 458)
        If FileExists(@ScriptDir & '\' & $sPluginPath & '\' & $sBanner) Then
            ;[TODO] Custom banner graphic
        Else
            _ResourceSetImageToCtrl($aPageCtrl[$iPageIndex][1], "INTROBANNER", $RT_RCDATA, $sResources)
        EndIf
        GUICtrlSetResizing($aPageCtrl[$iPageIndex][1], $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
    EndIf
    ; draw the banner "filler".
    If GUICtrlGetState($aPageCtrl[$iPageIndex][2]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][2], $GUI_SHOW)
    Else
        Local $sBannerFill = IniRead($sPage, "static", "bannerfill", "0x5a7094")
        $aPageCtrl[$iPageIndex][2] = GUICtrlCreateLabel("", 0, 456, 180, $aTTWinMainCurrentSize[1]-498)
        GUICtrlSetBkColor(-1, $sBannerFill)
        GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
    EndIf
    ; insert the HTML content
    If GUICtrlGetState($aPageCtrl[$iPageIndex][3]) > 0 Then
        GUICtrlSetState($aPageCtrl[$iPageIndex][3], $GUI_SHOW)
    Else
        $aPageCtrl[$iPageIndex][3] = GUICtrlCreateObj($oIE, 190, 10, $aTTWinMainCurrentSize[0]-200,$aTTWinMainCurrentSize[1]-60)
        GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
        _IENavigate($oIE, "about:blank")
    EndIf
    Local $sHTML = IniRead($sPage, "static", "content", $sPluginFilename & '.html')
    If FileExists(@ScriptDir & '\' & $sPluginPath & '\' & $sHTML) Then
        _IEDocWriteHTML($oIE, FileRead(@ScriptDir & '\' & $sPluginPath & '\' & $sHTML))
    Else
        _IEDocWriteHTML($oIE, FileRead(@ScriptDir & '\plugins\core\error.html'))
        _ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
                        'At section [common]; key "content"' & @CRLF & _
                        'File not found: "' & @ScriptDir & '\' & $sPluginPath & '\' & $sHTML & '"', _
                        0, $hTTWinMain, 0, -7)
    EndIf
    _IEAction($oIE, "refresh")
    Local $sScroll = IniRead($sPage, "static", "scroll", "0")
    If $sScroll = "0" Then
        $oIE.document.body.scroll = "no"
    EndIf
EndFunc
