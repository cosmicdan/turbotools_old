; Returns the array index of the request plugin|page data, or a new index if new page
Func findpage($pluginandpage, $isdraw)
    Local $iIndex = _ArraySearch($aPluginPage, $pluginandpage, 0, 0, 0, 1)
    If @error Then
        ;Not found, page is fresh
        Local $iPageCtrlIndex = UBound($aPluginPage, 1) ; get index of new element (UBound returns a value +1 than the index of array's last element)
        _ArrayAdd($aPluginPage, $pluginandpage & '|' & $iPageCtrlIndex) ; add the entry with third value of the new index to use for page controls
        __ArrayAdd($aPageCtrl, $pluginandpage)
        ; Return the index of $aPageCtrl where this page's data *will* be held
        echo ('    [#] Page ' & $pluginandpage & ' is new, creating page data at index ' & $iPageCtrlIndex)
        Return $iPageCtrlIndex
    Else
        ;page data exists
        Local $iPageCtrlIndex = StringReplace($aPluginPage[$iIndex], $pluginandpage & '|', "")
        If $isdraw = 1 Then
            ; Only echo debugging info on the draw i.e. not on the "recycle" stage of unloading a page
            echo ('    [#] Page ' & $pluginandpage & ' has existing data, re-use it (index ' & $iPageCtrlIndex & ')')
        EndIf
        ; Return the index of $aPageCtrl where this page's data is held
        Return $iPageCtrlIndex
    EndIf
EndFunc

Func _IniRead($sFile, $sSection, $sKey, $sDefaultValue = "0xDEAD 0xBEEF")
    Local $sIniReturn = IniRead($sFile, $sSection, $sKey, $sDefaultValue)
    If $sIniReturn = "0xDEAD 0xBEEF" Then
        ThrowError(1, $sKey)
        SetError(1)
    EndIf
    Return $sIniReturn
EndFunc