@echo off
setlocal
title Windows Bootloader Fixer
echo Program Name: Windows Bootloader Fixer
echo Version: 3.1.0
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
if /i "%BIOSType%"=="1" goto SureBIOSType
if /i "%BIOSType%"=="2" goto SureBIOSType
if /i "%BIOSType%"=="3" goto SureBIOSType
echo Invalid syntax!
goto Start

:SureBIOSType
echo.
set SureBIOSType=
set /p SureBIOSType="Are you sure your trying to fix %BIOSType%? (Yes/No) "
if /i "%SureBIOSType%"=="Yes" goto DriveLetterWindows
if /i "%SureBIOSType%"=="No" goto Start
echo Invalid syntax!
goto SureBIOSType

:DriveLetterWindows
echo.
set DriveLetterWindows=
set /p DriveLetterWindows="What is the drive letter that Windows is installed on? (A:-Z:) "
if /i "%DriveLetterWindows%"=="A:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="B:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="C:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="D:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="E:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="F:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="G:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="H:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="I:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="J:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="K:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="L:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="M:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="N:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="O:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="P:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="Q:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="R:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="S:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="T:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="U:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="V:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="W:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="X:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="Y:" goto CheckExistDriveLetterWindows
if /i "%DriveLetterWindows%"=="Z:" goto CheckExistDriveLetterWindows
echo Invalid syntax!
goto DriveLetterWindows

:CheckExistDriveLetterWindows
if not exist "%DriveLetterWindows%" goto DriveLetterWindowsNotExist
goto SureDriveLetterWindows

:DriveLetterWindowsNotExist
echo "%DriveLetterWindows%" does not exist! Please try again.
goto DriveLetterWindows

:SureDriveLetterWindows
echo.
set SureDriveLetterWindows=
set /p SureDriveLetterWindows="Are you sure %DriveLetterWindows% is the drive letter that Windows is installed on? (Yes/No) "
if /i "%SureDriveLetterWindows%"=="Yes" goto CheckExistDriveLetterWindows
if /i "%SureDriveLetterWindows%"=="No" goto DriveLetterWindows
echo Invalid syntax!
goto SureDriveLetterWindows

:DriveLetterBootloader
echo.
set DriveLetterBootloader=
set /p DriveLetterBootloader="What is the drive letter that the Windows bootloader is installed on? (A:-Z:) "
if /i "%DriveLetterWindows%"=="%DriveLetterBootloader%" goto SameDriveLetter
if /i "%DriveLetterBootloader%"=="A:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="B:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="C:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="D:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="E:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="F:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="G:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="H:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="I:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="J:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="K:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="L:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="M:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="N:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="O:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="P:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="Q:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="R:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="S:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="T:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="U:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="V:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="W:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="X:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="Y:" goto CheckExistDriveLetterBootloader
if /i "%DriveLetterBootloader%"=="Z:" goto CheckExistDriveLetterBootloader
echo Invalid syntax!
goto DriveLetterBootloader

:SameDriveLetter
echo.
echo "%DriveLetterBootloader%" is the same as "%DriveLetterWindows%"! Please try again.
goto DriveLetterWindows

:CheckExistDriveLetterBootloader
if not exist "%DriveLetterBootloader%" goto DriveLetterBootloaderNotExist
goto SureDriveLetterBootloader

:DriveLetterBootloaderNotExist
echo "%DriveLetterBootloader%" does not exist! Please try again.
goto DriveLetterBootloader

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
echo Fixing the Windows bootloader.
format "%DriveLetterBootloader%" /FS:FAT32 /Q /V:SYSTEM /Y > nul 2>&1
if not "%errorlevel%"=="0" goto Error
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f BIOS > nul 2>&1
if not "%errorlevel%"=="0" goto Error
goto Done

:UEFI
echo.
echo Fixing the Windows bootloader.
format "%DriveLetterBootloader%" /FS:FAT32 /Q /V:SYSTEM /Y > nul 2>&1
if not "%errorlevel%"=="0" goto Error
BCDBoot "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f UEFI > nul 2>&1
if not "%errorlevel%"=="0" goto Error
goto Done

:Both
echo.
echo Fixing the Windows bootloader.
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
