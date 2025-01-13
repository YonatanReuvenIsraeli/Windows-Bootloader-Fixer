@echo off
setlocal
title Windows Bootloader Fixer
echo Program Name: Windows Bootloader Fixer
echo Version: 4.1.8
echo License: GNU General Public License v3.0
echo Developer: @YonatanReuvenIsraeli
echo GitHub: https://github.com/YonatanReuvenIsraeli
echo Sponsor: https://github.com/sponsors/YonatanReuvenIsraeli
"%windir%\System32\net.exe" session > nul 2>&1
if not "%errorlevel%"=="0" goto "NotAdministrator"
"%windir%\System32\net.exe" user > nul 2>&1
if "%errorlevel%"=="0" set PERE=False
if not "%errorlevel%"=="0" set PERE=True
goto "DiskPartSet"

:"NotAdministrator"
echo.
echo Please run this batch file as an administrator. Press any key to close this batch file.
pause > nul 2>&1
goto "Close"

:"Close"
endlocal
exit

:"DiskPartSet"
set DiskPart=
goto "Disk"

:"Disk"
if exist "diskpart.txt" goto "DiskPartExistDisk"
echo.
echo Finding disks attached to this PC.
(echo list disk) > "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" 2>&1
if not "%errorlevel%"=="0" goto "DiskError"
del "diskpart.txt" /f /q > nul 2>&1
echo Disks attached to this PC found.
echo.
set Disk=
set /p Disk="What is the disk number that Windows is installed on? (0-?) "
goto "SureDisk"

:"DiskPartExistDisk"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "Disk"

:"DiskError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "NewPartition"

:"SureDisk"
echo.
set SureDisk=
set /p SureDisk="Are you sure disk %Disk% is the disk number that Windows is installed on? (Yes/No) "
if /i "%SureDisk%"=="Yes" goto "MBRGPT"
if /i "%SureDisk%"=="No" goto "Disk"
echo Invalid syntax!
goto "SureDisk"

:"MBRGPT"
echo.
set MBRGPT=
set /p MBRGPT="Is disk %Disk% MBR or GPT? (MBR/GPT) "
if /i "%MBRGPT%"=="MBR" goto "SureMBRGPT"
if /i "%MBRGPT%"=="GPT" goto "SureMBRGPT"
echo Invalid syntax!
goto "MBRGPT"

:"SureMBRGPT"
echo.
set SureMBRGPT=
if /i "%MBRGPT%"=="MBR" set /p SureMBRGPT="Are you sure disk %Disk% is MBR? (Yes/No) "
if /i "%MBRGPT%"=="GPT" set /p SureMBRGPT="Are you sure disk %Disk% is GPT? (Yes/No) "
if /i "%SureMBRGPT%"=="Yes" goto "BIOSType"
if /i "%SureMBRGPT%"=="No" goto "MBRGPT"
echo Invalid syntax!
goto "SureMBRGPT"

:"BIOSType"
echo.
echo [1] Legacy BIOS.
echo [2] UEFI.
echo [3] Both.
echo.
set BIOSType=
set /p BIOSType="Are you trying to fix legacy BIOS, UEFI or both? (1-3) "
if /i "%BIOSType%"=="1" goto "SureBIOSType"
if /i "%BIOSType%"=="2" goto "SureBIOSType"
if /i "%BIOSType%"=="3" goto "SureBIOSType"
echo Invalid syntax!
goto "BIOSType"

:"SureBIOSType"
echo.
set SureBIOSType=
if /i "%BIOSType%"=="1" set /p SureBIOSType="Are you sure you are trying to fix legacy BIOS? (Yes/No) "
if /i "%BIOSType%"=="2" set /p SureBIOSType="Are you sure you are trying to fix UEFI? (Yes/No) "
if /i "%BIOSType%"=="3" set /p SureBIOSType="Are you sure you are trying to fix both? (Yes/No) "
if /i "%SureBIOSType%"=="Yes" goto "Partition"
if /i "%SureBIOSType%"=="No" goto "BIOSType"
echo Invalid syntax!
goto "SureBIOSType"

:"Partition"
if exist "diskpart.txt" goto "DiskPartExistPartition"
echo.
echo Finding partitions in disk %Disk%.
(echo sel disk %Disk%) > "diskpart.txt"
(echo list part) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" 2>&1
if not "%errorlevel%"=="0" goto "PartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo Found partitions in disk %Disk%.
echo.
set Partition=
set /p Partition="What is the partition number of the boot partition? If there is no boot partition or boot partition needs to be remade enter "Need boot partition" (0-?/Need boot partition) "
if /i "%Partition%"=="Need boot partition" goto "SurePartition"
goto "SureBootPartition"

:"DiskPartExistPartition"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "Partition"

:"PartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "Disk"

:"SurePartition"
echo.
set SurePartition=
set /p SurePartition="Are you sure there is no boot partition or boot partition needs to be remade? (Yes/No) "
if /i "%SurePartition%"=="Yes" goto "ListPartition"
if /i "%SurePartition%"=="No" goto "Partition"
echo Invalid syntax!
goto "SurePartition"

:"ListPartition"
if exist "diskpart.txt" goto "DiskPartExistListPartition"
echo.
echo Listing partitions in disk %Disk%.
(echo sel disk %Disk%) > "diskpart.txt"
(echo list part) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" 2>&1
if not "%errorlevel%"=="0" goto "ListPartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo Partition listed in disk %Disk%.
echo.
set DeletePartition=
set /p DeletePartition="Enter partition number that needs to be deleted to make space for boot partition. Recomended size is 350 MB but you can try to go down to 100 MB if you do not have the space. Enter "Done" if you are done deleting partitions. (0-?/Done) "
if /i "%DeletePartition%"=="Done" goto "NewPartition"
goto "SureDeletePartition"

:"DiskPartExistDeletePartition"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "DeletePartition"

:"ListPartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "ListPartition"

:"SureDeletePartition"
echo.
set SureDeletePartition=
set /p SureDeletePartition="Are you sure you want to delete partition %DeletePartition%? (Yes/No) "
if /i "%SureDeletePartition%"=="Yes" goto "DeletePartition"
if /i "%SureDeletePartition%"=="No" goto "ListPartition"
echo Invalid syntax!
goto "SureDeletePartition"

:"DeletePartition"
if exist "diskpart.txt" goto "DiskPartExistDeletePartition"
echo.
echo Deleting partition %DeletePartition%.
(echo sel disk %Disk%) > "diskpart.txt"
(echo sel part %DeletePartition%) >> "diskpart.txt"
(echo del part override) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "DeletePartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo Partition %DeletePartition% deleted.
goto "ListPartition"

:"DiskPartExistDeletePartition"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "DeletePartition"

:"DeletePartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "DeletePartition"

:"NewPartition"
echo.
set Size=
set /p Size="Please enter boot partition size to create. Recomended size is 350 MB but you can try to go down to 100 MB if you do not have the space. (100-350) "
if not "%Size%" GEQ "100" goto "NotInRange"
if not "%Size%" LEQ "350" goto "NotInRange"
if exist "diskpart.txt" goto "DiskPartExistNewPartition"
echo.
echo Remaking boot parttion.
(echo sel disk %Disk%) > "diskpart.txt"
if /i "%MBRGPT%"=="MBR" (echo create partition primary size=%Size%) >> "diskpart.txt"
if /i "%MBRGPT%"=="GPT" (echo create partition efi size=%Size%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "NewPartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo Boot partition remade.
goto "Partition"

:"NotInRange"
echo %Size% is not in range! Please try again.
goto "NewPartition"

:"DiskPartExistNewPartition"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "NewPartition"

:"NewPartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "NewPartition"

:"SureBootPartition"
echo.
set SurePartition=
set /p SurePartition="All data on partition %Partition% will be deleted! Are you sure volume %Partition% is the boot partition? (Yes/No) "
if /i "%SurePartition%"=="Yes" goto "Volume1"
if /i "%SurePartition%"=="No" goto "Partition"
echo Invalid syntax!
goto "SureBootPartition"

:"Volume1"
if exist "diskpart.txt" goto "DiskPartExistVolume1"
echo.
echo Listing volumes attached to this PC.
(echo list vol) > "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" 2>&1
if not "%errorlevel%"=="0" goto "Volume1Error"
del "diskpart.txt" /f /q > nul 2>&1
echo Volumes attached to this PC listed.
goto "BootAsk1"

:"DiskPartExistVolume1"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "Volume1"

:"Volume1Error"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "Volume1"

:"BootAsk1"
echo.
set BootVolume=
set /p BootVolume="What volume is the boot volume? (0-?) "
goto "SureBootAsk1"

:"SureBootAsk1"
echo.
set SureBootAsk1=
set /p SureBootAsk1="All data on volume %BootVolume% will be deleted! Are you sure volume %BootVolume% is the boot volume? (Yes/No) "
if /i "%SureBootAsk1%"=="Yes" goto "BootAsk2"
if /i "%SureBootAsk1%"=="No" goto "Volume2"
echo Invalid syntax!
goto "SureBootAsk1"

:"BootAsk2"
echo.
set BootAsk2=
set /p BootAsk2="Is the boot volume %BootVolume% already assigned a drive letter? (Yes/No) "
if /i "%BootAsk2%"=="Yes" goto "SureBootAsk2"
if /i "%BootAsk2%"=="No" goto "BootloaderDriveLetter"
echo Invalid syntax!
goto "BootAsk2"

:"SureBootAsk2"
echo.
set SureBootAsk2=
set /p SureBootAsk2="Are you sure boot volume %BootVolume% is already assigned a drive letter? (Yes/No) "
if /i "%SureBootAsk2%"=="Yes" goto "DriveLetterBootloader"
if /i "%SureBootAsk2%"=="No" goto "BootAsk2"
echo Invalid syntax!
goto "SureBootAsk2"

:"BootloaderDriveLetter"
echo.
set BootloaderDriveLetter=
set /p BootloaderDriveLetter="Enter an unused drive letter. (A:-Z:) "
if exist "%BootloaderDriveLetter%" goto "DriveLetterBootloaderExist"
if /i "%BootloaderDriveLetter%"=="A:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="B:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="C:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="D:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="E:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="F:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="G:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="H:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="I:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="J:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="K:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="L:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="M:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="N:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="O:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="P:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="Q:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="R:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="S:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="T:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="U:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="V:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="W:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="X:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="Y:" goto "AssignDriveLetterBootloader"
if /i "%BootloaderDriveLetter%"=="Z:" goto "AssignDriveLetterBootloader"
echo Invalid syntax!
goto "BootloaderDriveLetter"

:"DriveLetterBootloaderExist"
echo "%BootloaderDriveLetter%" exists! Please try again.
goto "BootloaderDriveLetter"

:"DriveLetterBootloader"
echo.
set DriveLetterBootloader=
set /p DriveLetterBootloader="What is the drive letter of the boot volume? (A:-Z:) "
if /i "%DriveLetterBootloader%"=="A:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="B:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="C:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="D:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="E:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="F:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="G:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="H:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="I:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="J:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="K:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="L:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="M:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="N:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="O:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="P:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="Q:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="R:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="S:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="T:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="U:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="V:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="W:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="X:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="Y:" goto "SureDriveLetterBootloader"
if /i "%DriveLetterBootloader%"=="Z:" goto "SureDriveLetterBootloader"
echo Invalid syntax!
goto "DriveLetterBootloader"

:"SureDriveLetterBootloader"
echo.
set SureDriveLetterBootloader=
set /p SureDriveLetterBootloader="Are you sure "%DriveLetterBootloader%" is the boot volume drive letter? (Yes/No) "
if /i "%SureDriveLetterBootloader%"=="Yes" goto "CheckExistDriveLetterBootloader"
if /i "%SureDriveLetterBootloader%"=="No" goto "DriveLetterBootloader"
echo Invalid syntax!
goto "SureDriveLetterBootloader"

:"CheckExistDriveLetterBootloader"
if not exist "%DriveLetterBootloader%" goto "DriveLetterBootloaderNotExist"
goto "AssignDriveLetterBootloader"

:"DriveLetterBootloaderNotExist"
echo "%DriveLetterBootloader%" does not exist! Please try again.
goto "Volume1"

:"AssignDriveLetterBootloader"
if exist "diskpart.txt" goto "DiskPartExistAssignDriveLetterBootloader"
echo.
if /i "%BootAsk2%"=="No" echo Assigning drive letter "%BootloaderDriveLetter%" to boot partition and formating boot partition.
if /i "%BootAsk2%"=="Yes" echo Formating boot partition "%DriveLetterBootloader%".
(echo sel vol %BootVolume%) > "diskpart.txt"
(echo format fs=fat32 label="System" quick) >> "diskpart.txt"
if /i "%BootAsk2%"=="No" (echo assign letter=%BootloaderDriveLetter%) >> "diskpart.txt"
if /i "%MBRGPT%"=="MBR" (echo active) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "AssignDriveLetterBootloaderError"
if /i "%BootAsk2%"=="No" echo Drive letter "%BootloaderDriveLetter%" assigned to boot partition and boot partition "%BootloaderDriveLetter%" has been formated.
if /i "%BootAsk2%"=="Yes" echo Boot partition "%DriveLetterBootloader%" has been formated.
del "diskpart.txt" /f /q > nul 2>&1
set DriveLetterBootloader=%BootloaderDriveLetter%
goto "Volume2"

:"DiskPartExistAssignDriveLetterBootloader"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "AssignDriveLetterBootloader"

:"AssignDriveLetterBootloaderError"
del diskpart.txt /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "AssignDriveLetterBootloader"

:"Volume2"
if exist "diskpart.txt" goto "DiskPartExistVolume2"
echo.
echo Listing volumes in disk %Disk%.
(echo list vol) > "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" 2>&1
if not "%errorlevel%"=="0" goto "Volume2Error"
del "diskpart.txt" /f /q > nul 2>&1
echo Volumes in disk %Disk% listed.
goto "WindowsAsk1"

:"DiskPartExistVolume2"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "Volume2"

:"Volume2Error"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "Volume2"

:"WindowsAsk1"
echo.
set WindowsVolume=
set /p WindowsVolume="What volume is the Windows volume? (0-?) "
goto "SureWindowsAsk1"

:"SureWindowsAsk1"
echo.
set SureWindowsAsk1=
set /p SureWindowsAsk1="Are you sure volume %WindowsVolume% is the Windows volume? (Yes/No) "
if /i "%SureWindowsAsk1%"=="Yes" goto "WindowsAsk2"
if /i "%SureWindowsAsk1%"=="No" goto "Volume2"
echo Invalid syntax!
goto "SureWindowsAsk1"

:"WindowsAsk2"
echo.
set WindowsAsk=
set /p WindowsAsk="Is the Windows volume %WindowsVolume% already assigned a drive letter? (Yes/No) "
if /i "%WindowsAsk%"=="Yes" goto "SureWindowsAsk2"
if /i "%WindowsAsk%"=="No" goto "WindowsDriveLetter"
echo Invalid syntax!
goto "WindowsAsk2"

:"SureWindowsAsk2"
echo.
set SureWindowsAsk2=
set /p SureWindowsAsk2="Are you sure Windows volume %WindowsVolume% is already assigned a drive letter? (Yes/No) "
if /i "%SureWindowsAsk2%"=="Yes" goto "DriveLetterWindows"
if /i "%SureWindowsAsk2%"=="No" goto "WindowsAsk2"
echo Invalid syntax!
goto "SureWindowsAsk2"

:"WindowsDriveLetter"
echo.
set WindowsDriveLetter=
set /p WindowsDriveLetter="Enter an unused drive letter. (A:-Z:) "
if exist "%WindowsDriveLetter%" goto "WindowsDriveLetterExist"
if /i "%WindowsDriveLetter%"=="A:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="B:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="C:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="D:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="E:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="F:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="G:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="H:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="I:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="J:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="K:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="L:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="M:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="N:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="O:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="P:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="Q:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="R:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="S:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="T:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="U:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="V:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="W:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="X:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="Y:" goto "AssignDriveLetterWindows"
if /i "%WindowsDriveLetter%"=="Z:" goto "AssignDriveLetterWindows"
echo Invalid syntax!
goto "WindowsDriveLetter"

:"WindowsDriveLetterExist"
echo "%WindowsDriveLetter%" exists! Please try again.
goto "WindowsDriveLetter"

:"AssignDriveLetterWindows"
if exist "diskpart.txt" goto "DiskPartExistAssignDriveLetterWindows"
echo.
echo Assigning Windows volume %WindowsVolume% drive letter "%WindowsDriveLetter%".
(echo sel vol %WindowsVolume%) > "diskpart.txt"
(echo assign letter=%WindowsDriveLetter%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "AssignDriveLetterWindowsError"
del "diskpart.txt" /f /q > nul 2>&1
echo Assigned Windows volume %WindowsVolume% drive letter "%WindowsDriveLetter%".
set DriveLetterWindows=%WindowsDriveLetter%
goto "Bootloader"

:"DiskPartExistAssignDriveLetterWindows"
set DiskPart=True
echo.
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "AssignDriveLetterWindows"

:"AssignDriveLetterWindowsError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "WindowsDriveLetter"

:"DriveLetterWindows"
echo.
set DriveLetterWindows=
set /p DriveLetterWindows="What is the drive letter that Windows is installed on? (A:-Z:) "
if /i "%DriveLetterWindows%"=="A:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="B:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="C:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="D:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="E:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="F:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="G:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="H:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="I:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="J:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="K:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="L:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="M:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="N:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="O:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="P:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="Q:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="R:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="S:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="T:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="U:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="V:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="W:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="X:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="Y:" goto "SureDriveLetterWindows"
if /i "%DriveLetterWindows%"=="Z:" goto "SureDriveLetterWindows"
echo Invalid syntax!
goto "DriveLetterWindows"

:"SureDriveLetterWindows"
echo.
set SureDriveLetterWindows=
set /p SureDriveLetterWindows="Are you sure "%DriveLetterWindows%" is the drive letter that Windows is installed on? (Yes/No) "
if /i "%SureDriveLetterWindows%"=="Yes" goto "CheckExistDriveLetterWindows"
if /i "%SureDriveLetterWindows%"=="No" goto "DriveLetterWindows"
echo Invalid syntax!
goto "SureDriveLetterWindows"

:"CheckExistDriveLetterWindows"
if not exist "%DriveLetterWindows%" goto "DriveLetterWindowsNotExist"
if not exist "%DriveLetterWindows%"\Windows goto "NotWindows"
goto "Bootloader"

:"DriveLetterWindowsNotExist"
echo "%DriveLetterWindows%" does not exist! Please try again.
goto "DriveLetterWindows"

:"NotWindows"
echo Windows not installed on "%DriveLetterWindows%"!
goto "DriveLetterWindows"
goto "Volume2"

:"Bootloader"
echo.
echo Fixing the Windows bootloader.
if /i "%BIOSType%"=="1" "%windir%\System32\bcdboot.exe" "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f BIOS > nul 2>&1
if /i "%BIOSType%"=="2" "%windir%\System32\bcdboot.exe" "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f UEFI > nul 2>&1
if /i "%BIOSType%"=="3" "%windir%\System32\bcdboot.exe" "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f ALL > nul 2>&1
if not "%errorlevel%"=="0" goto "ErrorBootloader"
goto "Volume3"

:"ErrorBootloader"
echo There was an error and no new bootloader was created. You can try again.
goto "Disk"

:"Volume3"
if exist "diskpart.txt" goto "DiskPartExistVolume3"
(echo sel vol %BootVolume%) > "diskpart.txt"
(echo remove letter=%DriveLetterBootloader%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "Volume3Error"
del "diskpart.txt" /f /q > nul 2>&1
if /i "%DiskPart%"=="True" goto "DiskPartDone"
if /i "%PERE%"=="False" goto "DoneExit"
if /i "%PERE%"=="True" goto "DoneReboot"

:"DiskPartExistVolume3"
set DiskPart=True
echo Please temporary rename to something else or temporary move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder you ran this batch file from. Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "Volume3"

:"Volume3Error"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "Volume3"

:"DiskPartDone"
echo.
echo You can now rename or move back the file back to "diskpart.txt".
if /i "%PERE%"=="False" goto "DoneExit"
if /i "%PERE%"=="True" goto "DoneReboot"

:"DoneExit"
endlocal
echo Your bootloader is fixed! Press any key to exit.
pause > nul 2>&1
exit

:"DoneReboot"
endlocal
echo Your bootloader is fixed! Press any key to reboot.
pause > nul 2>&1
"%windir%\System32\wpeutil.exe" Reboot
