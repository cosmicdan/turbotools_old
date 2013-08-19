
Local $hSplashBar, $hSplashBarctrl
#Region ;~~~~~~~~~~START DrawInSplashScreen
If $bCfgSplash Then
    Global $hSplashGUI = GUICreate("Splash", 373, 128, -1, -1, $WS_POPUP + $WS_DISABLED, $WS_EX_LAYERED + $WS_EX_TOPMOST + $WS_EX_TOOLWINDOW)
        GUISetState()
    For $i = 0 To 255 Step 8
        drawPNG($i)
    Next
    Local $tmp = WinGetPos($hSplashGUI)
    $hSplashBar = GUICreate("SplashBar", 338, 10, $tmp[0]+28, $tmp[1]+111, $WS_POPUP + $WS_DISABLED, $WS_EX_TOPMOST + $WS_EX_TOOLWINDOW)
        GUISetBkColor (0x444444)
        GUISetState()
    $hSplashBarctrl = GUICtrlCreateProgress (1, 1, 336, 8, $PBS_SMOOTH)
        GUICtrlSetData(-1, 13)
    ;GUICtrlSetData($hSplashBarctrl, 37)
    #EndRegion ;~~~~~~~~~~END DrawInSplashScreen

    GUICtrlSetData($hSplashBarctrl, 75)
EndIf

DoConfig()
echo ("[#] Loading core includes...")
#include "buttonrow.au3"
#include "errorhandler.au3"
#include "datahelper.au3"
#include "echo.au3"
#include "config.au3"
echo ("[#] Loading static page templates...")
#include "..\plugins\core\inc\page_static.au3"
#include "..\plugins\core\inc\page_static_error.au3"
#include "..\plugins\core\inc\page_static_options.au3"
#include "..\plugins\core\inc\page_static_welcome.au3"
#include "..\plugins\core\inc\page_static_selector2x2.au3"
echo ("[#] Loading task page templates...")
#include "..\plugins\core\inc\page_task.au3"
#include "..\plugins\core\inc\page_task_selectrom.au3"
echo ("[#] Loading Tool Windows...")
#include "..\1plugins\core\inc\toolwindow_about.au3"

If $bCfgSplash Then
    #Region ;~~~~~~~~~~START DrawOutSplashScreen
    GUICtrlSetData($hSplashBarctrl, 100)
    Sleep(100)
    GUIDelete($hSplashBar)
    GUISwitch($hSplashGUI)
    For $i = 255 To 0 Step -8
        drawPNG($i)
    Next
    GUIDelete($hSplashGUI)
    #EndRegion ;~~~~~~~~~~END DrawOutSplashScreen
    ;_GDIPlus_ShutDown()
EndIf

Func drawPNG($i)
    Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend
    Local $hSplashImage = _ResourceGetAsImage("SPLASH", $RT_RCDATA, $sResources)
    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hSplashImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hSplashImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hSplashImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $i)
    Const $AC_SRC_ALPHA = 1    ;moved here from outside func
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)
    _WinAPI_UpdateLayeredWindow($hSplashGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
    Sleep(5)
    GUISetState()
EndFunc