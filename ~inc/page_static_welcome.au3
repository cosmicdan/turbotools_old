Func page_static_welcome($sPage, $sPluginPath, $sPluginFilename, $iData)
	; draw the banner
	If GUICtrlGetState($aPageCtrl[$iData][1]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][1], $GUI_SHOW)
	Else
		Local $sBanner = IniRead($sPage, "static", "banner", "0")
		$aPageCtrl[$iData][1] = GUICtrlCreatePic("", 0, 0, 180, 458)
		If FileExists(@ScriptDir & '\' & $sPluginPath & '\' & $sBanner) Then
			;[TODO] Custom banner graphic
		Else
			_ResourceSetImageToCtrl($aPageCtrl[$iData][1], "INTROBANNER", $RT_RCDATA, $sResources)
		EndIf
		GUICtrlSetResizing($aPageCtrl[$iData][1], $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	EndIf
	; draw the banner "filler".
	If GUICtrlGetState($aPageCtrl[$iData][2]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][2], $GUI_SHOW)
	Else
		Local $sBannerFill = IniRead($sPage, "static", "bannerfill", "0x5a7094")
		$aPageCtrl[$iData][2] = GUICtrlCreateLabel("", 0, 456, 180, $aTTWinMainCurrentSize[1]-498)
		GUICtrlSetBkColor(-1, $sBannerFill)
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
	EndIf
	; insert the HTML content
	If GUICtrlGetState($aPageCtrl[$iData][3]) > 0 Then
		GUICtrlSetState($aPageCtrl[$iData][3], $GUI_SHOW)
	Else
		$aPageCtrl[$iData][3] = GUICtrlCreateObj($oIE, 190, 10, $aTTWinMainCurrentSize[0]-200,$aTTWinMainCurrentSize[1]-60)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM)
		_IENavigate($oIE, "about:blank")
	EndIf
	Local $sHTML = IniRead($sPage, "static", "content", $sPluginFilename & '.html')
	If FileExists(@ScriptDir & '\' & $sPluginPath & '\' & $sHTML) Then
		_IEDocWriteHTML($oIE, FileRead(@ScriptDir & '\' & $sPluginPath & '\' & $sHTML))
	Else
		_IEDocWriteHTML($oIE, FileRead(@ScriptDir & '\plugins\core\error.html'))
		_ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
						'At section [common]; key "content"' & @CRLF & _
						'File not found: "' & @ScriptDir & '\' & $sPluginPath & '\' & $sHTML & '"', _
						0, $hTTWinMain, 0, -7)
	EndIf
	_IEAction($oIE, "refresh")
	Local $sScroll = IniRead($sPage, "static", "scroll", "0")
	If $sScroll = "0" Then
		$oIE.document.body.scroll = "no"
	EndIf
EndFunc


#comments-start
Func Page1()
	echo("[i] Page 1 - Welcome")
	_GUICtrlButton_Enable($APSBtn[3], false) ; Disable back button
	_GUICtrlButton_Show($APSBtn[2], true) ; Show about button
	_GUICtrlButton_Show($APSBtn[4], true) ; Show next button
	$APSPage[0] = GUICtrlCreateLabel("Welcome to Android ProShop!", 200, 20, $APSWinMainCurrentSize[0]-220, 28)
		GUICtrlSetFont(-1, 16, 500, Default, "Arial", 5)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	$APSPage[1] = GUICtrlCreateIcon($resources, -3, 313, 134, 16, 16)
		GUICtrlSetTip(-1, "" & @CR & "That's right =)", "Example info", 1, 1)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	$APSPage[2] = GUICtrlCreatePic("", 0, 0, 180, 458)
		_ResourceSetImageToCtrl(-1, "INTROBANNER", $RT_RCDATA, $resources)
		GUICtrlSetResizing(-1, $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
	$APSPage[3] = GUICtrlCreateLabel("", 0, 456, 180, $APSWinMainCurrentSize[1]-499)
		GUICtrlSetBkColor(-1, 0x777777)
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
	$APSPage[4] = GUICtrlCreateLabel("APS v" & $sysVer & "  -  " & $sysRev, 200, 50, $APSWinMainCurrentSize[0]-220, 30)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
		GUICtrlSetFont(-1, 8.5, 400, 2, "Arial", 5)
	$APSPage[5] = GUICtrlCreateLabel("This program will guide you through the process of customizing your Android ROM." & @CRLF & @CRLF & @CRLF _
		& "Whenever you see the         icon next to a certain option, you can hover the mouse over it to see some context-sensitive info. Try it now! If more info is available, the tip may mention that it can be clicked; this will usually open a certain web page with your default browser." _
		, 200, 100, $APSWinMainCurrentSize[0]-220, 80 )
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	$APSPage[6] = GUICtrlCreateLabel("", 200, $APSWinMainCurrentSize[1]-180, $APSWinMainCurrentSize[0]-220, 1)
		GUICtrlSetBkColor(-1, 0x777777)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	$APSPage[7] =  GUICtrlCreateLabel("Note that APS is currently alpha-quality software. Some features and functions may be missing, erroneous (buggy) or have otherwise unpredictable or undesirable effects. The creator and all contributors take no responsibility for any damage or data loss that may occur.", 200, $APSWinMainCurrentSize[1]-260, $APSWinMainCurrentSize[0]-220, 70 )
		GUICtrlSetFont(-1, 10, 700, Default, "Arial", 5)
		GUICtrlSetColor(-1, 0xcc0000)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	$APSPage[8] = GUICtrlCreateLabel("Android ProShop is licenced under the Simplified BSD (2-clause) agreement. Portions - such as some of the graphics - are under other agreements. Please see the included Licence.txt [TODO:DOCS] for more information, or visit the homepage of APS (see the 'About' section).", 200, $APSWinMainCurrentSize[1]-166, $APSWinMainCurrentSize[0]-220, 50)
		GUICtrlSetFont(-1, 8.5, 400, 2, "Arial", 5)
		GUICtrlSetColor(-1, 0x444444)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	$APSPage[9] =  GUICtrlCreateLabel("Before continuing, ensure you have a ZIP of your chosen custom ROM ready along with any additional extras for customization. See the documentation [TODO:DOCS] for more information.", 200, $APSWinMainCurrentSize[1]-100, $APSWinMainCurrentSize[0]-220, 70)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
EndFunc
#comments-end