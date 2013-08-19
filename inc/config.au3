Func DoConfig()
    ;tempdir
    $sTempDir = IniRead(@ScriptDir & "\..\Settings.ini", "core", "tempdir", "0")
    If $sTempDir = "0" Then
        echo("    [i] Settings - tempdir not specified. Writing-out default value - 'usertemp' (currently " & @TempDir & ")")
        $sTempDir = "usertemp"
        IniWrite(@ScriptDir & "\..\Settings.ini", "core", "tempdir", "usertemp")
    EndIf
    $sTempDir = StringReplace($sTempDir, "usertemp", @TempDir) ;replace default/special 'usertemp' keyword with real temp path
    Switch _FileWriteAccessible($sTempDir)
        Case 1
            echo("    [#] Settings - tempdir is valid and writable (" & $sTempDir & ")")
            ; [TODO]
        Case 2
            echo("    [!] Settings - tempdir access is denied *or* the directory is locked by another program (" & $sTempDir & ")")
            ; [TODO]
        Case 3
            echo("    [!] Settings - tempdir access is denied. Do you have the correct permissions? (" & $sTempDir & ")")
            ; [TODO]
        Case 4
            echo("    [!] Settings - tempdir is not found - it should be changed. (" & $sTempDir & ")")
            Local $sConfigResult = _ExtMsgBox(48, "&Yes|No (Quit)", $sSysTitle, "Your previously set temporary folder is not found. Reset it to default?", 0)
            If $sConfigResult = 1 Then
                echo("        [!] Settings - tempdir is being reset to 'usertemp' (" & @TempDir & ")")
                ;[TODO] reset to default
            Else
                TTQuit()
            EndIf
    EndSwitch
    ; [TODO] Check if %temp%\turbotoolsttemp (or whatever) exists, and if specific files are detected then perform some kind of crash recovery
EndFunc


Func _FileWriteAccessible($sFile)
    ; Returns
    ;            1 = Success, file is writeable and deletable
    ;            2 = Access Denied because of lacking access rights OR because file is open by another process
    ;             3 = File is set "Read Only" by attribute
    ;            4 = File not found
    If Not FileExists("\\?\" & $sFile) Then Return 4 ; File not found
    If StringInStr(FileGetAttrib("\\?\" & $sFile), "R", 2) Then Return 3 ; Read-Only Flag set
    Local $hFile = _WinAPI_CreateFileEx("\\?\" & $sFile, 3, 2, 7, 0x02000000)
    If $hFile = 0 Then Return 2 ; File not accessible, UAC issue?
    _WinAPI_CloseHandle($hFile)
    Return 1 ; Success
EndFunc   ;==>_FileWriteAccessible