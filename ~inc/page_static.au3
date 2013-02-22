Func DoPageStatic($sPage, $sPluginPath, $sPluginFilename, $iIndexOfPageData)
	Local $aPageStatic = IniReadSection($sPage, "static")
	If @error Then
		_ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
						'Section not found: [static]', _
						0, $hTTWinMain, 0, -4)
	Else
		Local $sPageType = IniRead($sPage, "static", "type", "0")
		If $sPageType = "0" Then
			_ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
					'At section [static]' & @CRLF & _
					'Key not found: "type"', _
					0, $hTTWinMain, 0, -4)
		Else
			Select
				Case $sPageType = "welcome"
					DoPageStaticWelcome($sPage, $sPluginPath, $sPluginFilename, $iIndexOfPageData)
				Case Else
					_ExtMsgBox($sResources, 0, "Internal Error", 'Error in ' & $sPluginPath & '\' & $sPluginFilename & '.ini' & @CRLF & _
							'At section [static]; key "type"' & @CRLF & _
							'Unknown value: "' & $sPageType & '"', _
							0, $hTTWinMain, 0, -4)
			EndSelect
		EndIf
	EndIf
EndFunc