#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=~resources\ICON_000_MAIN.ico
#AutoIt3Wrapper_Outfile=Turbo Tools.exe
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Turbo Tools
#AutoIt3Wrapper_Res_Description=All-in-one tool for customizing Android
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=CosmicDan 2012
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-d
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~START Initialization
echo("[#] Turbo Tools booting...")

#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <StructureConstants.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <StaticConstants.au3>
#include <ProgressConstants.au3>
#include <AVIConstants.au3>
#include <GuiImageList.au3>
#include <GuiButton.au3>
#include <EditConstants.au3>
#include <FontConstants.au3>
#include <IE.au3>
#include <Array.au3>

_IEErrorHandlerRegister()

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Opt("MustDeclareVars", 1)

#include "~udf\ArrayAdd2D.au3"
#include "~udf\ExtMsgBox.au3"
#include "~udf\GUICtrlSetOnHover.au3"
#include "~udf\Icons.au3"
#include "~udf\MD5.au3"
#include "~udf\pZip.au3"
#include "~udf\ReduceMem.au3"
#include "~udf\Resources.au3"


Global $sResources = @ScriptDir & '\resources.dll'
Global $sSysTitle = "Turbo Tools"
Global $sSysVer = FileGetVersion(@ScriptFullPath)
Global $sSysRev = "Build " & FileGetVersion(@ScriptFullPath, "Timestamp")


Global $aTTWinMainCurrentSize
Global $aPluginPage[1] ;dynamic size array
Global $aPageCtrl[1][99] ;dynamic size of pages, max of 99 elements per page
; Init globals for buttonrow
Global $bButtonRow_CustomTask
; Init globals for pagination
Global $sCurrentPlugin
Global $sCurrentPage
Global $sPreviousPage ; used internally for pagination
Global $oIE = _IECreateEmbedded() ; persistent embedded IE object saves active x object (re/un)loading
; Data globals
Global $iPageIndex ; needed since we can't pass parameters to control-event functions
Global $sPage ; as above
; globals for "toolwindow" dialogs (about, debug, etc)
Global $hToolWindow, $hToolWindowHyperlink1, $hToolWindowCloseBtn

_ExtMsgBoxSet(1, 0, -1, -1, -1, -1)

If FileExists($sResources) Then
    ; TODO - Verify resources.dll file here
Else
    _ExtMsgBox(16, "Close", $sSysTitle, "Resources file not found. Please reinstall Turbo Tools.", 0)
    Exit
EndIf

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END Initialization

Global $bCfgSplash = 0
Global $bCfgQuickQuit = 1
#include "~inc\boot.au3"
Boot()

#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~MAIN

echo ("[#] Loading main GUI...")
Opt("GUIResizeMode", $GUI_DOCKAUTO)
Global $hTTWinMain = GUICreate($sSysTitle, 700, 500, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_SIZEBOX))
    setIcon(1)
    GUISetFont(9, 400, Default, "Trebuchet MS", -1, 5)
    GUISetBkColor (0xeeecde)
    Opt("GUIResizeMode", $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
    GUISetOnEvent($GUI_EVENT_CLOSE, "TTWinMainSysEvent")
    Global $hTTWinMainMinimumSize = WinGetPos($hTTWinMain) ; we need this for MY_WM_GETMINMAXINFO since the client size specified upon creation is exclusive of titlebar and borders
        GUIRegisterMsg(0x24, "MY_WM_GETMINMAXINFO")

echo ("[#] Loading core includes...")
#include "~inc\buttonrow.au3"
#include "~inc\datahelper.au3"
echo ("[#] Loading static page templates...")
#include "~inc\page_static.au3"
#include "~inc\page_static_error.au3"
#include "~inc\page_static_welcome.au3"
#include "~inc\page_static_selector2x2.au3"
echo ("[#] Loading task page templates...")
#include "~inc\page_task.au3"
#include "~inc\page_task_selectrom.au3"
echo ("[#] Loading Tool Windows...")
#include "~inc\toolwindow_about.au3"
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
    $sPage = @ScriptDir & '\plugins\' & $plugin & '\' & $inifile & '.ini'
    If FileExists($sPage) = "0" Then
        _ExtMsgBox($sResources, 0, "Internal Error", 'Page not found:' & @CRLF & _
                                        'plugins\' & $plugin & '\' & $inifile & '.ini', _
                                        0, $hTTWinMain, 0, -7)
        ; [TODO] User option to either cancel pagination, or do the hard-fault as it does now. Default would be to cancel and return to previous page, since the hard fault is useful only to those making plugins
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
    Else
        Select
            Case $pagetype = "static"
                DoPageStatic('plugins\' & $plugin, $inifile)
            Case $pagetype = "task"
                DoPageTask('plugins\' & $plugin, $inifile)
            Case Else
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $plugin & '\' & $inifile & '.ini' & @CRLF & _
                            'At section [common]; key "type"' & @CRLF & _
                            'Unknown value: "' & $pagetype & '"', _
                            0, $hTTWinMain, 0, -7)
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
                _ExtMsgBox($sResources, 0, $sSysTitle, "Nothing to configure yet =)", 10, $hTTWinMain, 0, -13)
            EndIf
        Case $hTTBtn[2]
            If _GUICtrlButton_GetText($hTTBtn[2]) = "About..." Then
                DialogAbout()
            EndIf
        Case $hTTBtn[3] ; custom
            Local $sCustomTask = IniRead(@ScriptDir & '\plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini', "buttonrow", "customtask", "debugpane")
            _ExtMsgBox($sResources, 0, $sSysTitle, "[TODO] - Show options for debugging Turbo Tools", 10, $hTTWinMain, 0, -5)
            ;$sPreviousPage = $sCurrentPage
        Case $hTTBtn[4] ; back
            Local $sBackPage = IniRead(@ScriptDir & '\plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini', "buttonrow", "backpage", "0")
            If $sBackPage = "0" Then
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini' & @CRLF & _
                    'At section [buttonrow]' & @CRLF & _
                    'Key not found: "backpage"', _
                    0, $hTTWinMain, 0, -7)
            Else
                $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
                DrawPage($sCurrentPlugin, $sBackPage)
            EndIf
        Case $hTTBtn[5] ; next
            Local $sNextPage = IniRead(@ScriptDir & '\plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini', "buttonrow", "nextpage", "0")
            If $sNextPage = "0" Then
                _ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $sCurrentPlugin & '\' & $sCurrentPage & '.ini' & @CRLF & _
                    'At section [buttonrow]' & @CRLF & _
                    'Key not found: "nextpage"', _
                    0, $hTTWinMain, 0, -7)
            Else
                $sPreviousPage = $sCurrentPlugin & "|" & $sCurrentPage
                DrawPage($sCurrentPlugin, $sNextPage)
            EndIf
        Case $hTTBtn[6]
            ;If _GUICtrlButton_GetText($hTTBtn[6]) = "Cancel" Then
                ; [TODO] do cancel stuff instead of quit
            ;Else
                TTQuit()
            ;EndIf
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
        If $result = 1 Then
            echo ("[#] User quit")
            Exit
        EndIf
    Else
        Exit
    EndIf
EndFunc

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Internel Event Handlers

Func MY_WM_GETMINMAXINFO($hWnd, $Msg, $wParam, $lParam)
    Local $minmaxinfo = DllStructCreate("int;int;int;int;int;int;int;int;int;int",$lParam)
    DllStructSetData($minmaxinfo,7,$hTTWinMainMinimumSize[2]) ; min X
    DllStructSetData($minmaxinfo,8,$hTTWinMainMinimumSize[3]) ; min Y
    Return 0
EndFunc

Func RuntimeProc()
    _ReduceMemory(0)
EndFunc

Func echo($in)
    ; ShellExecute("eventcreate", '/L Application /T INFORMATION /SO TurboTools /ID 1 /D "Hello!"', -1, "open", @SW_HIDE)
    ; Note to self - Event Log requires administrator rights
    ConsoleWrite ($in & @CRLF)
EndFunc

Func setIcon($index)
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

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
