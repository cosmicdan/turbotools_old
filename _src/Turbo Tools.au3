#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\_resources\ICON_000_MAIN.ico
#AutoIt3Wrapper_Outfile=..\Turbo Tools.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=Turbo Tools
#AutoIt3Wrapper_Res_Description=All-in-one tool for customizing Android
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=CosmicDan 2013
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-d
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global $sLoaderFile

If FileExists(@ScriptDir & "\..\inc\main.au3") Then
    ; uncompiled loader
    $sLoaderFile = @ScriptDir & "\..\inc\main.au3"
EndIf

If FileExists(@ScriptDir & "\inc\main.au3") Then
    ; compiled
    $sLoaderFile = @ScriptDir & "\inc\main.au3"
EndIf

If Not FileExists($sLoaderFile) Then
    ; throw error
    MsgBox(4096, "Error", "Couldn't find main.au3")
EndIf

RunWait(@AutoItExe & " /ErrorStdOut /AutoIt3ExecuteScript " & $sLoaderFile)
