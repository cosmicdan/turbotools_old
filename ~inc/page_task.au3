Func DoPageTask($sPluginPath, $sPluginFilename)
    Local $aPageTask = IniReadSection($sPage, "task")
    If @error Then
        _ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
                        'Section not found: [task]', _
                        0, $hTTWinMain, 0, -4)
        GUISwitch($hTTWinMain)
    Else
        Local $sPageType = IniRead($sPage, "task", "type", "0")
        If $sPageType = "0" Then
            _ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
                    'At section [task]' & @CRLF & _
                    'Key not found: "type"', _
                    0, $hTTWinMain, 0, -4)
            GUISwitch($hTTWinMain)
        Else
            Call ("page_task_" & $sPageType, $sPluginPath, $sPluginFilename)
            If @error = 0xDEAD And @extended = 0xBEEF Then
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
                            'At section [task]; key "type"' & @CRLF & _
                            'Unknown page type: "page_task_' & $sPageType & '"', _
                            0, $hTTWinMain, 0, -7)
                GUISwitch($hTTWinMain)
            EndIf
        EndIf
    EndIf
EndFunc
