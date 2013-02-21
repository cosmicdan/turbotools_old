#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\~resources\ICON_099_MAIN.ico
#AutoIt3Wrapper_Outfile=Turbo Tools.exe
#AutoIt3Wrapper_Compression=4
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

_IEErrorHandlerRegister()

Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Opt("MustDeclareVars", 1)

#include "~udf\ExtMsgBox.au3"
#include "~udf\GUICtrlSetOnHover.au3"
#include "~udf\Resources.au3"
#include "~udf\ReduceMem.au3"

Global $sResources = @ScriptDir & '\resources.dll'
Global $sSysTitle = "Turbo Tools"
Global $sSysVer = "0.1.0.0"
Global $sSysRev = "Free and Open-Source"


Global $aTTWinMainCurrentSize
Global $aPageCtrl[99] ; Maximum of 100 controls per page
; Init globals for buttonrow
Global $bButtonRow_CustomTask

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
	GUISetFont(9, 400, Default, "Arial", -1, 5)
	GUISetBkColor (0xeeecde)
	Opt("GUIResizeMode", $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	GUISetOnEvent($GUI_EVENT_CLOSE, "TTWinMainSysEvent")
	Global $hTTWinMainMinimumSize = WinGetPos($hTTWinMain) ; we need this for MY_WM_GETMINMAXINFO since the client size specified upon creation is exclusive of titlebar and borders
		GUIRegisterMsg(0x24, "MY_WM_GETMINMAXINFO")

echo ("[#] Loading core includes...")
#include "~inc\about.au3"
#include "~inc\buttonrow.au3"
echo ("[#] Loading page templates...")
#include "~inc\page_static.au3"
#include "~inc\page_static_welcome.au3"
echo ("[i] Running.")

GUISetState(@SW_SHOW)
DrawPage("core", "page_welcome")

While 1
	Sleep(30000) ; thirty seconds
	RuntimeProc()
WEnd



echo (" ")
echo (" ")
echo ("!!!!!!!!!")
echo ("Bad Exit! Loop was broken! Probable interpreter crash...!")

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Region ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Global Event Handlers

Func DrawPage($plugin, $inifile)
	; Remove all page controls before drawing new page
	If IsArray($aPageCtrl) Then
		Local $sPageCtrlCount = UBound($aPageCtrl)
		For $i = 0 to $sPageCtrlCount  - 1 ; clear page
			GUICtrlDelete($aPageCtrl[$i])
		Next
	EndIf
	; Remove button row elements before drawing new page
	RemoveButtons()
	; Get current window dimensions before drawing new page
	$aTTWinMainCurrentSize = WinGetClientSize ($hTTWinMain)
	; Start processing page INI
	Local $sPage = @ScriptDir & '\plugins\' & $plugin & '\' & $inifile & '.ini'
	If FileExists($sPage) = "0" Then
		_ExtMsgBox($sResources, 0, "Internal Error", 'Page not found:' & @CRLF & _
										'plugins\' & $plugin & '\' & $inifile & '.ini', _
										0, $hTTWinMain, 0, -4)
	EndIf
	Local $buttonrow = IniRead($sPage, "common", "buttonrow", "0")
	If $buttonrow = "1" Then
		Local $aTTBtn = IniReadSection($sPage, "buttonrow")
		If @error Then
			_ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $plugin & '\' & $inifile & '.ini' & @CRLF & _
						'Section not found: [buttonrow]', _
						0, $hTTWinMain, 0, -4)
		Else
			DoButtonBar()
			For $i = 1 To $aTTBtn[0][0]
				DoButtonRow($aTTBtn[$i][0],$aTTBtn[$i][1])
			Next
		EndIf
	EndIf
	Local $pagetype = IniRead($sPage, "common", "type", "0")
	If $pagetype = "0" Then
		_ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $plugin & '\' & $inifile & '.ini' & @CRLF & _
					'At section [common]' & @CRLF & _
					'Key not found: "type"', _
					0, $hTTWinMain, 0, -4)
	Else
		Select
			Case $pagetype = "static"
				DoPageStatic($sPage, 'plugins\' & $plugin, $inifile)
			Case $pagetype = "task"
				;not implemented
			Case Else
				_ExtMsgBox($sResources, 0, "Internal Error", 'Error in plugins\' & $plugin & '\' & $inifile & '.ini' & @CRLF & _
							'At section [common]; key "type"' & @CRLF & _
							'Unknown value: "' & $pagetype & '"', _
							0, $hTTWinMain, 0, -4)
		EndSelect
	EndIf
EndFunc

#comments-start
Func DrawPage_old($task)
	If IsArray($TTPage) Then
		Local $NumberOfControls = UBound($TTPage)
		;echo("Items in the array: " & $NumberOfControls)
		For $i = 0 to $NumberOfControls  - 1 ; clear page
			GUICtrlDelete($APSPage[$i])
		Next
		Global $APSPage = 0
		Global $APSPage[99]
	EndIf
	$aTTWinMainCurrentSize = WinGetClientSize ($hTTWinMain)
	Select
		Case $task = 1; next page
			;$APSPageCurrent = $APSPageCurrent + 1
			;Call ("Page" & $APSPageCurrent)
		Case $task = 0 ; back a page
			;$APSPageCurrent = $APSPageCurrent - 1
			;Call ("Page" & $APSPageCurrent)
		Case $task < 0 ; specific page is requested
			$task = StringReplace($task, "-", "")
			;$APSPageCurrent = $task
			;Call ("Page" & $task)
	EndSelect
	_ReduceMemory(0)
EndFunc
#comments-end

Func TTWinMainSysEvent()
	Switch @GUI_CTRLID
		Case $GUI_EVENT_CLOSE
			TTQuit()
	EndSwitch
EndFunc

Func TTWinMainButtonEvent()
	Local $hCtrl = @GUI_CtrlId
	_ExtMsgBox($sResources, 0, $sSysTitle, $hCtrl, 10, $hTTWinMain, 0, -10)
	Switch @GUI_CtrlId
		Case $hTTBtn[1]
			If _GUICtrlButton_GetText($hTTBtn[1]) = "Options..." Then
				_ExtMsgBox($sResources, 0, $sSysTitle, "Nothing to configure yet =)", 10, $hTTWinMain, 0, -10)
			EndIf
		Case $hTTBtn[2]
			If _GUICtrlButton_GetText($hTTBtn[2]) = "About..." Then
				DialogAbout()
			EndIf
		Case $hTTBtn[3] ; custom
			_ExtMsgBox($sResources, 0, $sSysTitle, "You pressed 'Custom' button", 10, $hTTWinMain, 0, -10)
		Case $hTTBtn[4] ; back
			_ExtMsgBox($sResources, 0, $sSysTitle, "You pressed 'Back' button", 10, $hTTWinMain, 0, -10)
		Case $hTTBtn[5] ; next
			_ExtMsgBox($sResources, 0, $sSysTitle, "You pressed 'Next' button", 10, $hTTWinMain, 0, -10)
		Case $hTTBtn[6]
			If _GUICtrlButton_GetText($hTTBtn[6]) = "Quit" Then
				TTQuit()
			EndIf
	EndSwitch
EndFunc


Func BackGoesHome() ; jump-home function (from distant/irregular page numbers)
	echo("[i] Jump-home")
	GUICtrlSetOnEvent($hTTBtn[3], "TTWinMainButtonEvent") ; Reset to standard behavior
	;DrawPage(-2)
EndFunc

Func TTQuit()
	If Not $bCfgQuickQuit Then
		; If pending task, show "warning - tasks pending" prompt
		Local $result = _ExtMsgBox($sResources, 4, $sSysTitle, "Are you sure you want to quit?" & @CRLF & _
									"All selected changes will be lost.", 0, $hTTWinMain, 0, -3)
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
	;_GUICtrlButton_SetImageList($button, $icon, 0, 84, 0, -116, 20)
	_GUICtrlButton_SetImageList($button, $icon, 0, 81, 0, -113, 20)
EndFunc

#EndRegion ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~