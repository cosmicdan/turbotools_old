Func DialogAbout()
	GUISetState(@SW_DISABLE, $hTTWinMain)
	$hToolWindow = GUICreate("About Android ProShop", 404, 470, -1, -1, $WS_POPUP + $WS_BORDER, -1, $hTTWinMain)
		setIcon(1)
		;GUISetBkColor(0xf0f0f0)
		GUICtrlCreatePic("",0,0,404,470)
			_ResourceSetImageToCtrl(-1, "ABOUTBOX", $RT_RCDATA, $sResources)
			GuiCtrlSetState(-1,$GUI_DISABLE)
		GUICtrlCreateLabel("Version " & $sSysVer & @CRLF & $sSysRev, 150, 114, 216, 46, $SS_Center)
		$hToolWindowHyperlink1 = GUICtrlCreateLabel("Created by CosmicDan", 0, 160, 404, -1, $SS_Center)
			GuiCtrlSetFont(-1, -1, -1, 4) ; underlined
			GuiCtrlSetColor(-1,0x0000ff)
			GuiCtrlSetCursor(-1,0)
			GUICtrlSetOnEvent(-1, "ToolWindowEvent")
		$hToolWindowCloseBtn = GUICtrlCreateButton ("Close", 306, 432, 92, 32)
			GUICtrlSetOnEvent (-1, "ToolWindowEvent")
		GUICtrlCreateLabel("Credits and Thanks:", 0, 176, 404, -1, $SS_Center)
		GUICtrlCreateEdit("", 12, 194, 382, 230, BitOr($ES_AUTOVSCROLL, $ES_CENTER, $ES_MULTILINE, $ES_READONLY, $WS_VSCROLL))
			GUICtrlSetData(-1, _
				"'Turbine' icon designed by" & @CRLF _
				& "Hrvoje Bielen" & @CRLF _
				& @CRLF _
				& "Icon set by FatCow Hosting" & @CRLF _
				& "CC BY 3.0" & @CRLF _
				& "http://www.fatcow.com/free-icons/" & @CRLF _
				& @CRLF _
				& "Code snippets, libraries and other AutoIt contributions:" & @CRLF _
				& "Melba23, photonbuddy, YellowLab, MrCreatoR," & @CRLF _
				& "w_Outer, Rajesh V R, Prog@ndy, Zedna, wraithdu" & @CRLF _
				& @CRLF _
			)
			GUICtrlSetState(-1, $GUI_FOCUS)
	GUISetState(@SW_SHOW, $hToolWindow)
EndFunc
