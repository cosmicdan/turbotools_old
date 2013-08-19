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

Func DoPluginIncludes($sScanPlugin)
    ; [TODO] Check if the plugin is disabled
    Local $hIncludeFile
    Local $sIncludeFileContents
    If FileExists(@ScriptDir & "\..\plugins\current_includes.au3") Then
        echo("    [#] Plugin list found, scanning and adding new includes if required...")
        $hIncludeFile = FileOpen(@ScriptDir & "\..\plugins\current_includes.au3", 1)
        $sIncludeFileContents = FileRead (@ScriptDir & "\..\plugins\current_includes.au3")
    Else
        ; first run
        echo("    [#] Plugin list NOT found, searching for all includes and adding ...")
        $hIncludeFile = FileOpen(@ScriptDir & "\..\plugins\current_includes.au3", 1)
        $sIncludeFileContents = ""
    EndIf
    Local $sIncludeLine
    Local $sIncludes = _FileListToArray(@ScriptDir & "\..\plugins\" & $sScanPlugin & "\inc", "*.au3", 1)
    For $i = 1 To $sIncludes[0]
        $sIncludeLine = '#include "' & $sScanPlugin & '\inc\' & $sIncludes[$i] & '"'
        ;echo($sIncludeLine)
        Local $iPosition = StringInStr($sIncludeFileContents, $sIncludeLine)
        If $iPosition = 0 Then
            ; not found, add it to the file
            FileWriteLine($hIncludeFile, $sIncludeLine)
            echo("        [i] Added " & $sScanPlugin & "\inc\" & $sIncludes[$i])
        EndIf
    Next
    FileClose($hIncludeFile)
EndFunc