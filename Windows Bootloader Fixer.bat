@echo off
setlocal
title Windows Bootloader Fixer
echo Windows Bootloader Fixer v1.0.3
echo.
echo Please run this batch file as an administrator.
goto Start

:Start
echo.
echo [1] Legacy BIOS
echo [2] UEFI
echo [3] Both
set BIOSType=
set /p BIOSType="Are you trying to fix Legacy BIOS, UEFI or both? (1-3) "
if "%BIOSType%"=="1" goto DriveLetterWindows
if "%BIOSType%"=="2" goto DriveLetterWindows
if "%BIOSType%"=="3" goto DriveLetterWindows
echo Invalid Syntax!
goto Start

:DriveLetterWindows
echo.
set DriveLetterWindows=
set /p DriveLetterWindows="What is the Drive letter that Windows is installed on? (A:-Z:) "
if /i "%DriveLetterWindows%"=="A:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="B:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="C:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="D:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="E:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="F:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="G:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="H:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="I:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="J:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="K:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="L:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="M:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="N:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="O:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="P:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="Q:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="R:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="S:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="T:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="U:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="V:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="W:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="X:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="Y:" goto SureDriveLetterWindows
if /i "%DriveLetterWindows%"=="Z:" goto SureDriveLetterWindows
echo Invalid Syntax!
goto DriveLetterWindows

:SureDriveLetterWindows
echo.
set SureDriveLetterWindows=
set /p SureDriveLetterWindows="Are you sure %DriveLetterWindows% is the Drive letter that Windows is installed on? (Yes/No) "
if /i "%SureDriveLetterWindows%"=="Yes" goto DriveLetterBootloader
if /i "%SureDriveLetterWindows%"=="No" goto DriveLetterWindows
echo Invalid Syntax!
goton SureDriveLetterWindows

:DriveLetterBootloader
echo.
set DriveLetterBootloader=
set /p DriveLetterBootloader="What is the Drive letter that the Windows Bootloader is installed on? (A:-Z:) "
if /i "%DriveLetterBootloader%"=="A:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="B:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="C:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="D:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="E:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="F:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="G:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="H:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="I:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="J:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="K:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="L:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="M:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="N:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="O:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="P:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="Q:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="R:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="S:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="T:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="U:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="V:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="W:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="X:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="Y:" goto SureDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="Z:" goto SureDriveLetterBootloader
echo Invalid Syntax!
goto DriveLetterBootloader

:SureDriveLetterBootloader
echo.
set SureDriveLetterBootloader=
set /p SureDriveLetterBootloader="Are you sure %DriveLetterBootloader% the Drive letter that the Windows Bootloader is installed on? (Yes/No) "
if /i "%SureDriveLetterBootloader%"=="Yes" goto BIOSType
if /i "%SureDriveLetterBootloader%"=="No" goto DriveLetterBootloader
echo Invalid Syntax!
goto SureDriveLetterBootloader

:BIOSType
if "%BIOSType%"=="1" goto LegacyBIOS
if "%BIOSType%"=="2" goto UEFI
if "%BIOSType%"=="3" goto Both

:LegacyBIOS
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f BIOS
if not errorlevel 0 goto Error
goto Done

:UEFI
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f UEFI
if not errorlevel 0 goto Error
goto Done

:Both
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f ALL
if not errorlevel 0 goto Error
goto Done

:Error
echo There was an error and no new bootloader was created. You can try again.
goto Start

:Done
endlocal
echo Your Windows bootloader is fixed! Press any key to close this batch file.
pause > nul
exit
