Func ThrowError($iType, $sBlamed)
    GUISwitch($hTTWinMain)
    $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
    Switch $iType
        Case 1
            ; Requested keyname was not found at all in the INI file
            echo ("[!] Error! Requested INI file '" & $sCurrentPage & "' in plugin '" & $sCurrentPlugin & "' has no entry called '" & $sBlamed & "'.")
            $sExtraData = "Requested INI file '" & $sCurrentPage & "' in plugin '" & $sCurrentPlugin & "' has no entry called '" & $sBlamed & "'."
    EndSwitch
    DrawPage("core", "page_error")
    Return 0
EndFunc