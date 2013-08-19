@echo off
SETLOCAL EnableDelayedExpansion
::---------------------------
echo [i] Building ResHacker script...
echo [FILENAMES] > _build.ini
echo Exe=_Resources.dll >> _build.ini
echo SaveAs=Resources.dll >> _build.ini
echo Log=_Resources.log >> _build.ini
echo. >> _build.ini
echo [COMMANDS] >> _build.ini
:: icons
SET COUNT=0
FOR %%f IN (*.ico) DO (
    SET /A COUNT=!COUNT!+1
    echo -add %%f, IconGroup,!COUNT!, >> _build.ini
)
:: RCDATA
FOR %%f IN (*.png) DO (
   CALL :ADDRCDATA %%f
)
::---------------------------
echo [i] Running ResHacker script...
del Resources.dll >nul 2>nul
del ..\Resources.dll >nul 2>nul
.\bin\ResHackerFX  -script "_build.ini"
type *.log
del *.log
del _build.ini
move Resources.dll ..
echo.
echo Done. Press any key to exit.
pause>nul
GOTO :EOF

:ADDRCDATA
SET RCDATAFILENAME=%~n1
SET RCDATANAME=!RCDATAFILENAME:RCDATA_=!
echo -add %1, RCDATA,!RCDATANAME!, >> _build.ini