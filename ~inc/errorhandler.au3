Func ThrowError($iType, $sBlamed)
    GUISwitch($hTTWinMain)
    $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
    ; [TODO] User option to either cancel pagination, or do the hard-fault as it does now. Default would be to cancel and return to previous page, since the hard fault is useful only to those making plugins.
    DrawPage("core", "page_error")
    If $bDebug Then Return 0
    Switch $iType
        Case 1
            ; Requested keyname was not found at all in the INI file
            echo ("[!] Error! Requested INI file '" & $sCurrentPage & "' in plugin '" & $sCurrentPlugin & "' has no entry called '" & $sBlamed & "'.")
                _ExtMsgBox($sResources, 0, "Internal Error", 'Requested key not found in INI file.' & @CRLF & _
                                           'This plugin is broken or incomplete. See log for details.', _
                                           0, $hTTWinMain, 0, -7)
    EndSwitch
    Return 0
EndFunc