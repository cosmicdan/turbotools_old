#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=ICON_099_MAIN.ico 											; index: 0
#AutoIt3Wrapper_Outfile=..\resources.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Turbo Tools
#AutoIt3Wrapper_Res_Description=All-in-one tool for customizing Android
#AutoIt3Wrapper_Res_Fileversion=0.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=CosmicDan 2012
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Res_Icon_Add=ICON_004_INFO.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_005_ASK.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_006_ERROR.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_007_WARN.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_008_PREV.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_009_NEXT.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_010_REFRESH.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_011_EXIT.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_012_OPTIONS.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_013_TASK01.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_014_TASK02.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_015_TASK03.ico
#AutoIt3Wrapper_Res_Icon_Add=ICON_016_TASK04.ico
#AutoIt3Wrapper_Res_File_Add=RCDATA_ABOUTBOX.png, rt_rcdata, ABOUTBOX
#AutoIt3Wrapper_Res_File_Add=RCDATA_SPLASH.png, rt_rcdata, SPLASH
#AutoIt3Wrapper_Res_File_Add=RCDATA_INTROBANNER.png, rt_rcdata, INTROBANNER
#AutoIt3Wrapper_Res_File_Add=RCDATA_BANNER.png, rt_rcdata, BANNER
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-d
#AutoIt3Wrapper_Run_After=move /y "%scriptdir%\..\resources.exe" "%scriptdir%\..\resources.dll"
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Local $hTurboTools = Run('"' & @ScriptDir & '\main.exe"' & $CmdLineRaw, '"' & @ScriptDir & '"')
