#NoTrayIcon
#AutoIt3Wrapper_Run_AU3Check=n
#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~START Initialization

; core AutoIt includes
#include "coreincludes.au3"

; The debug flag makes slight modifications to GUI elements and workflow to try and make development/testing easier. This bool is assigned later in boot
Global $bDebug
;Draw Debugging window
Global $hDebugConsoleWin = GUICreate("TT Console", 700, 300, 40, 40, BitOR($WS_POPUP, $WS_CAPTION, $WS_SYSMENU))
Global $hDebugConsoleTxt = _GUICtrlRichEdit_Create($hDebugConsoleWin, "", 0, 0, 700, 300, BitOR($ES_NOHIDESEL, $ES_MULTILINE, $ES_READONLY, $WS_HSCROLL, $WS_VSCROLL, $ES_AUTOVSCROLL))


echo("[#] Turbo Tools booting...")

_IEErrorHandlerRegister()

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Opt("MustDeclareVars", 1)
Opt("WinTitleMatchMode", 3) ; exact title match

#include "..\inc\udf\ArrayAdd2D.au3"
#include "..\inc\udf\ExtMsgBox.au3"
#include "..\inc\udf\GUICtrlSetOnHover.au3"
#include "..\inc\udf\Icons.au3"
#include "..\inc\udf\MD5.au3"
#include "..\inc\udf\pZip.au3"
#include "..\inc\udf\ReduceMem.au3"
#include "..\inc\udf\Resources.au3"
#include "..\inc\udf\WinAPIEx.au3"


Global $sResources = @ScriptDir & '\..\resources.dll'
Global $sSysTitle = "Turbo Tools"
Global $sSysVer = FileGetVersion(@ScriptFullPath)
Global $sSysRev = "Build " & FileGetVersion(@ScriptFullPath, "Timestamp")

Global $hTTWinMain
Global $aTTWinMainCurrentSize
Global $aPluginPage[1] ;dynamic size array
Global $aPageCtrl[1][99] ;dynamic size of pages, max of 99 elements per page
; Init globals for buttonrow
Global $bButtonRow_CustomTask
; Init globals for pagination
Global $sCurrentPlugin
Global $sCurrentPage
Global $sPreviousPage ; used internally for pagination
Global $sReturnPage ; used for returning from options
Global $oIE = _IECreateEmbedded() ; persistent embedded IE object saves active x object (re/un)loading
; Data globals
Global $iPageIndex ; needed since we can't pass parameters to control-event functions
Global $sPage ; as above
; globals for "toolwindow" dialogs (about, debug, etc)
Global $hToolWindow, $hToolWindowHyperlink1, $hToolWindowCloseBtn
; the "extra" data field is a somewhat arbitrary variable that is used in a variety of places to pass data around
Global $sExtraData = False
; The background color we need to apply to in-tab controls
Global $sTabCtrlBk = _WinAPI_GetSysColor($COLOR_WINDOW)
; Settings
Global $sTempDir


_ExtMsgBoxSet(1, 0, -1, -1, -1, -1)

If FileExists($sResources) Then
    ; [TODO] - Verify resources.dll file here
Else
    _ExtMsgBox(16, "Close", $sSysTitle, "Resources file not found. Please reinstall Turbo Tools.", 0)
    Exit
EndIf

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END Initialization

Global $bCfgSplash = 1 ;show splash screen by default
Global $bCfgQuickQuit = 0 ;confirm quit by default

If Not @Compiled Then
    ; faster stuff for debug runs
    $bCfgSplash = 0
    $bCfgQuickQuit = 1
EndIf
#include "..\inc\boot.au3"

#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MAIN

echo ("[#] Loading main GUI...")
Opt("GUIResizeMode", $GUI_DOCKAUTO)
$hTTWinMain = GUICreate($sSysTitle, 700, 500, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_SIZEBOX))
    setWindowIcon(1)
    GUISetFont(9, 400, Default, "Trebuchet MS", -1, 5)
    GUISetBkColor (0xeeecde)
    Opt("GUIResizeMode", $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
    GUISetOnEvent($GUI_EVENT_CLOSE, "TTWinMainSysEvent")
    Global $hTTWinMainMinimumSize = WinGetPos($hTTWinMain) ; we need this for MY_WM_GETMINMAXINFO since the client size specified upon creation is exclusive of titlebar and borders
        GUIRegisterMsg(0x24, "MY_WM_GETMINMAXINFO")
        GUIRegisterMsg($WM_SIZE, "_WM_SIZE")

;The debug flag makes slight modifications to GUI elements and workflow to try and make development/testing easier
If Not @Compiled Then
    ;enable if not compiled
    echo("[!] Uncompiled script, running in debugging mode")
    $bDebug = True
    echo("    [i] Showing TT Console... hello there!")
    GUISetState(@SW_SHOW, $hDebugConsoleWin) ; display console window
    setWindowIcon(1)
    GUISwitch($hTTWinMain)
ElseIf FileExists(@ScriptDir & '\debug') Then
    ;enable if "debug" file exists in program folder
    echo("[!] .\debug flag found, running in debugging mode")
    $bDebug = True
    $bCfgQuickQuit = 1
    echo("    [i] Showing TT Console... hello there!")
    GUISetState(@SW_SHOW, $hDebugConsoleWin) ; display console window
    setWindowIcon(1)
    GUISwitch($hTTWinMain)
EndIf

echo ("[i] Running.")

GUISetState(@SW_SHOW)
DoButtonBar()
HideButtons()
DrawPage("core", "page_welcome")
; above is default, other DrawPage commands below are for debugging or [future] loading some associated file e.g. preset or batch task
;DrawPage("core", "page_maintask")
;DrawPage("core", "page_task_rom_intro")

While 1
    Sleep(11000) ; eleven seconds
    RuntimeProc()
WEnd



echo (" ")
echo (" ")
echo ("!!!!!!!!!")
echo ("Bad Exit! Loop was broken! Probable interpreter crash...!")

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Global Event Handlers

Func DrawPage($plugin, $inifile)
    echo ("[i] Loading page '" & $inifile & "' from " & $plugin & " plugin")
    GUISwitch($hTTWinMain)
    ; update globals
    $sCurrentPlugin = $plugin
    $sCurrentPage = $inifile
    ; Get current window dimensions before drawing new page
    $aTTWinMainCurrentSize = WinGetClientSize ($hTTWinMain)
    If Not $sPreviousPage = "" Then
        ; we've moved a page, hide all previous controls
        $iPageIndex = findpage($sPreviousPage, 0)
        For $i = 0 to 98 ; hide all controls on page
            GUICtrlSetState($aPageCtrl[$iPageIndex][$i], $GUI_HIDE)
        Next
    EndIf
    ; gather page data
    $iPageIndex = findpage($plugin & '|' & $inifile, 1)
    ; error checks
    ; [TODO] Verify requested plugin folder exists
    $sPage = @ScriptDir & '\..\plugins\' & $plugin & '\' & $inifile & '.ini'
    If FileExists($sPage) = "0" Then
        echo ("[!] Error! Requested INI file at 'plugins\" & $plugin & "\" & $inifile & ".ini' does not exist - requested by " & $sPreviousPage)
        $sExtraData = "The page '" & $inifile & "' was not found in the plugin '" & $plugin & "'."
        $sPage = @ScriptDir & '\plugins\core\page_error.ini'
        $plugin = 'core'
        $inifile = 'page_error'
    EndIf
    ; Hide buttons before redrawing them
    HideButtons()
    ; Start processing page INI
    Local $buttonrow = IniRead($sPage, "common", "buttonrow", "0")
    If $buttonrow = "1" Then
        Local $aTTBtn = IniReadSection($sPage, "buttonrow")
        If @error Then
            _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $plugin & '\' & $inifile & '.ini' & @CRLF & _
                        'Section not found: [buttonrow]', _
                        0, $hTTWinMain, 0, -7)
            GUISwitch($hTTWinMain)
        Else
            For $i = 1 To $aTTBtn[0][0]
                DoButtonRow($aTTBtn[$i][0],$aTTBtn[$i][1], 'plugins\' & $plugin & '\' & $inifile & '.ini')
            Next
        EndIf
    EndIf
    Local $pagetype = IniRead($sPage, "common", "type", "0")
    If $pagetype = "0" Then
        _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $plugin & '\' & $inifile & '.ini' & @CRLF & _
                    'At section [common]' & @CRLF & _
                    'Key not found: "type"', _
                    0, $hTTWinMain, 0, -7)
        GUISwitch($hTTWinMain)
    Else
        Select
            Case $pagetype = "static"
                DoPageStatic('..\plugins\' & $plugin, $inifile)
            Case $pagetype = "task"
                DoPageTask('..\plugins\' & $plugin, $inifile)
            Case Else
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $plugin & '\' & $inifile & '.ini' & @CRLF & _
                            'At section [common]; key "type"' & @CRLF & _
                            'Unknown value: "' & $pagetype & '"', _
                            0, $hTTWinMain, 0, -7)
                GUISwitch($hTTWinMain)
        EndSelect
    EndIf
EndFunc

Func TTWinMainSysEvent()
    Switch @GUI_CTRLID
        Case $GUI_EVENT_CLOSE
            TTQuit()
    EndSwitch
EndFunc

Func TTWinMainButtonEvent()
    Switch @GUI_CtrlId
        Case $hTTBtn[1]
            If _GUICtrlButton_GetText($hTTBtn[1]) = "Options..." Then
                ;_ExtMsgBox($sResources, 0, $sSysTitle, "Options not implemented yet.", 10, $hTTWinMain, 0, -13)
                ;GUISwitch($hTTWinMain)
                $sReturnPage = $sCurrentPlugin & "|" & $sCurrentPage ; Return page must be set when either quit=cancel or nextpage=save
                $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
                DrawPage("core", "page_options")
            EndIf
        Case $hTTBtn[2]
            If _GUICtrlButton_GetText($hTTBtn[2]) = "About..." Then
                DialogAbout()
            EndIf
        Case $hTTBtn[3] ; custom
            Local $sCustomTask = IniRead(@ScriptDir & '\..\plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini', "buttonrow", "customtask", "debugpane")
            If $sCustomTask = "debugpane" Then
                GUISetState(@SW_SHOW, $hDebugConsoleWin) ; display console window
                WinActivate("TT Console")
            Else
                _ExtMsgBox($sResources, 0, $sSysTitle, "Error - requested custom task '" & $sCustomTask & "' is not valid.", 10, $hTTWinMain, 0, -5)
                GUISwitch($hTTWinMain)
            EndIf
            ;$sPreviousPage = $sCurrentPage
        Case $hTTBtn[4] ; back
            Local $sBackPage = IniRead(@ScriptDir & '\..\plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini', "buttonrow", "backpage", "0")
            If $sBackPage = "0" Then
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini' & @CRLF & _
                    'At section [buttonrow]' & @CRLF & _
                    'Key not found: "backpage"', _
                    0, $hTTWinMain, 0, -7)
                GUISwitch($hTTWinMain)
            Else
                $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
                DrawPage($sCurrentPlugin, $sBackPage)
            EndIf
        Case $hTTBtn[5] ; next
            Local $sNextPage = IniRead(@ScriptDir & '\..\plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini', "buttonrow", "nextpage", "0")
            If $sNextPage = "0" Then
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini' & @CRLF & _
                    'At section [buttonrow]' & @CRLF & _
                    'Key not found: "nextpage"', _
                    0, $hTTWinMain, 0, -7)
                GUISwitch($hTTWinMain)
            Else
                If $sNextPage = "save" Then
                    ; special keyword for saving options
                    ; [TODO] Save options to INI
                    echo("    [#] All options have been saved")
                    OptionsRestoreButtonrow() ; reset the buttonrow
                    GUISetBkColor (0xeeecde, $hTTWinMain) ; restore the custom GUI background color
                    Local $sReturnPluginPage = StringSplit($sReturnPage, "|")
                    $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
                    DrawPage($sReturnPluginPage[1], $sReturnPluginPage[2])
                Else
                    $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
                    DrawPage($sCurrentPlugin, $sNextPage)
                EndIf
            EndIf
        Case $hTTBtn[6]
            Local $sQuitButtonType = IniRead(@ScriptDir & '\..\plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini', "buttonrow", "quit", "quit")
            If $sQuitButtonType = "cancel" Then
                echo("    [!] Changed options have been discarded")
                OptionsRestoreButtonrow() ; reset the buttonrow
                GUISetBkColor (0xeeecde, $hTTWinMain) ; restore the custom GUI background color
                Local $sReturnPluginPage = StringSplit($sReturnPage, "|")
                $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
                DrawPage($sReturnPluginPage[1], $sReturnPluginPage[2])
            Else
                TTQuit()
            EndIf
    EndSwitch
EndFunc

Func ToolWindowEvent()
    Switch @GUI_CtrlId
        Case $hToolWindowCloseBtn
            GUIDelete ($hToolWindow)
            GUISetState(@SW_ENABLE, $hTTWinMain)
            GUISwitch($hTTWinMain)
            ; Active the main window a few times to work-around a strange AutoIt idiosynchrasy
            WinActivate($sSysTitle)
            WinActivate($sSysTitle)
            WinActivate($sSysTitle)
        Case $hToolWindowHyperlink1
            ShellExecute("http://forum.xda-developers.com/member.php?u=1844875")
    EndSwitch
EndFunc

Func TTQuit()
    If Not $bCfgQuickQuit Then
        ; If pending task, show "warning - tasks pending" prompt
        Local $result = _ExtMsgBox($sResources, 4, $sSysTitle, "Are you sure you want to quit?" & @CRLF & _
                                    "All selected changes will be lost.", 0, $hTTWinMain, 0, -6)
        GUISwitch($hTTWinMain)
        If $result = 1 Then
            echo ("[#] User quit")
            GUIDelete($hDebugConsoleWin)
            GUIDelete($hTTWinMain)
            Exit
        EndIf
    Else
        echo ("[#] User quit")
        GUIDelete($hDebugConsoleWin)
        GUIDelete($hTTWinMain)
        Exit
    EndIf
EndFunc

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Internel Event Handlers

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
    If $hWnd = $hTTWinMain Then
        Local $minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int",$lParam)
        DllStructSetData($minmaxinfo,7,$hTTWinMainMinimumSize[2]) ; min X
        DllStructSetData($minmaxinfo,8,$hTTWinMainMinimumSize[3]) ; min Y
        Return 0
    EndIf
EndFunc

Func RuntimeProc()
    _ReduceMemory(0)
EndFunc

Func setWindowIcon($index)
    If @Compiled AND $index=1 Then
        GUISetIcon (@AutoItExe, -1)
    Else
        GUISetIcon ($sResources, -$index)
    EndIf
EndFunc

Func ButtonIcon($button, $index)
    Local $icon = _GUIImageList_Create(16, 16, 5, 3)
        _GUIImageList_AddIcon($icon, $sResources, $index)
    _GUICtrlButton_SetImageList($button, $icon, 0, 8, 2, -4)
EndFunc

Func ButtonIcon32($button, $index)
    Local $icon = _GUIImageList_Create(32, 32, 5, 3)
        _GUIImageList_AddIcon($icon, $sResources, $index, true)
    _GUICtrlButton_SetImageList($button, $icon, 4, 1, -10, 1)
EndFunc

Func _WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
    $aTTWinMainCurrentSize = WinGetClientSize ($hTTWinMain)
    Call("_WM_SIZE___" & $sCurrentPlugin & "_" & $sCurrentPage, 0, 0, 0, 0)
EndFunc

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
