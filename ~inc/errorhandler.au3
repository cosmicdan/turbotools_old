Func ThrowError($iType, $sBlamed)
    Switch $iType
        Case 1
            ; Requested page entry (keyname) was not found at all in the INI file
            _ExtMsgBox($sResources, 0, "Internal Error", 'Data not found for:' & @CRLF & _
                                        $sBlamed & @CRLF & _
                                        '...see the log for further details.', _
                                        0, $hTTWinMain, 0, -7)
            echo ("[!] Error! Currrent page '" & $sCurrentPage & "' in plugin '" & $sCurrentPlugin & "' has no data for the requested entry '" & $sBlamed & "'. Page INI file is either broken or incomplete.")
    EndSwitch
    $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
    ; [TODO] User option to either cancel pagination, or do the hard-fault as it does now. Default would be to cancel and return to previous page, since the hard fault is useful only to those making plugins
    DrawPage("core", "page_error")
EndFunc