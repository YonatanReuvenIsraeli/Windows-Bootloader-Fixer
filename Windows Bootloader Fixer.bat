@echo off
setlocal
title Windows Bootloader Fixer
echo Program Name: Windows Bootloader Fixer
echo Version: 3.0.3
echo Developer: @YonatanReuvenIsraeli
echo Website: https://www.yonatanreuvenisraeli.dev
echo License: GNU General Public License v3.0
net session > nul 2>&1
if not "%errorlevel%"=="0" goto NotAdministrator
goto Start

:NotAdministrator
echo.
echo Please run this batch file as an administrator. Press any key to close this batch file.
pause > nul 2>&1
goto Close

:Close
endlocal
exit batch file as an administrator.

:Start
echo.
echo [1] Legacy BIOS
echo [2] UEFI
echo [3] Both
set BIOSType=
set /p BIOSType="Are you trying to fix Legacy BIOS, UEFI or both? (1-3) "
if /i "%BIOSType%"=="1" goto DriveLetterWindows
if /i "%BIOSType%"=="2" goto DriveLetterWindows
if /i "%BIOSType%"=="3" goto DriveLetterWindows
echo Invalid syntax!
goto Start

:DriveLetterWindows
echo.
set DriveLetterWindows=
set /p DriveLetterWindows="What is the drive letter that Windows is installed on? (A:-Z:) "
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
echo Invalid syntax!
goto DriveLetterWindows

:SureDriveLetterWindows
echo.
set SureDriveLetterWindows=
set /p SureDriveLetterWindows="Are you sure %DriveLetterWindows% is the drive letter that Windows is installed on? (Yes/No) "
if /i "%SureDriveLetterWindows%"=="Yes" goto DriveLetterBootloader
if /i "%SureDriveLetterWindows%"=="No" goto DriveLetterWindows
echo Invalid syntax!
goto SureDriveLetterWindows

:DriveLetterBootloader
echo.
set DriveLetterBootloader=
set /p DriveLetterBootloader="What is the drive letter that the Windows bootloader is installed on? (A:-Z:) "
if /i "%DriveLetterWindows%"=="%DriveLetterBootloader%" goto SameDriveLetter
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
echo Invalid syntax!
goto DriveLetterBootloader

:SameDriveLetter
echo.
echo "%DriveLetterWindows%" is the same as "%DriveLetterBootloader%"! Please try again.
goto DriveLetterWindows

:SureDriveLetterBootloader
echo.
set SureDriveLetterBootloader=
set /p SureDriveLetterBootloader="All data on drive "%DriveLetterBootloader%" will be deleted! Are you sure "%DriveLetterBootloader%" is the drive letter that the Windows bootloader is installed on? (Yes/No) "
if /i "%SureDriveLetterBootloader%"=="Yes" goto BIOSType
if /i "%SureDriveLetterBootloader%"=="No" goto DriveLetterBootloader
echo Invalid syntax!
goto SureDriveLetterBootloader

:BIOSType
if /i "%BIOSType%"=="1" goto LegacyBIOS
if /i "%BIOSType%"=="2" goto UEFI
if /i "%BIOSType%"=="3" goto Both

:LegacyBIOS
echo.
echo Fixing bootloader.
format "%DriveLetterBootloader%" /FS:FAT32 /Q /V:SYSTEM /Y > nul 2>&1
if not "%errorlevel%"=="0" goto Error
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f BIOS > nul 2>&1
if not "%errorlevel%"=="0" goto Error
goto Done

:UEFI
echo.
echo Fixing bootloader.
format "%DriveLetterBootloader%" /FS:FAT32 /Q /V:SYSTEM /Y > nul 2>&1
if not "%errorlevel%"=="0" goto Error
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f UEFI > nul 2>&1
if not "%errorlevel%"=="0" goto Error
goto Done

:Both
echo.
echo Fixing bootloader.
format "%DriveLetterBootloader%" /FS:FAT32 /Q /V:SYSTEM /Y > nul 2>&1
if not "%errorlevel%"=="0" goto Error
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f ALL > nul 2>&1
if not "%errorlevel%"=="0" goto Error
goto Done

:Error
echo There was an error and no new bootloader was created. You can try again.
goto Start

:Done
endlocal
echo Your Windows bootloader is fixed! Press any key to close this batch file.
pause > nul 2>&1
exit
