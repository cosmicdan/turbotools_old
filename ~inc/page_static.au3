Func DoPageStatic($sPluginPath, $sPluginFilename)
    Local $aPageStatic = IniReadSection($sPage, "static")
    If @error Then
        _ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
                        'Section not found: [static]', _
                        0, $hTTWinMain, 0, -4)
    Else
        Local $sPageType = IniRead($sPage, "static", "type", "0")
        If $sPageType = "0" Then
            _ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
                    'At section [static]' & @CRLF & _
                    'Key not found: "type"', _
                    0, $hTTWinMain, 0, -4)
        Else
            Call ("page_static_" & $sPageType, $sPluginPath, $sPluginFilename)
            If @error = 0xDEAD And @extended = 0xBEEF Then
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
                            'At section [static]; key "type"' & @CRLF & _
                            'Unknown page type: "page_static_' & $sPageType & '"', _
                            0, $hTTWinMain, 0, -7)
            EndIf
        EndIf
    EndIf
EndFunc
