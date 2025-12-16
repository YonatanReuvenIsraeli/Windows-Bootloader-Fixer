@echo off
title Windows Bootloader Fixer
setlocal
echo Program Name: Windows Bootloader Fixer
echo Version: 8.1.9
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
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
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
if /i "%MBRGPT%"=="MBR" if /i "%SureMBRGPT%"=="Yes" goto "BIOSType"
if /i "%MBRGPT%"=="GPT" if /i "%SureMBRGPT%"=="Yes" goto "Partition"
if /i "%SureMBRGPT%"=="No" goto "MBRGPT"
echo Invalid syntax!
goto "SureMBRGPT"

:"BIOSType"
echo.
echo [1] Legacy BIOS.
echo [2] Both legacy BIOS and UEFI.
echo.
set BIOSType=
set /p BIOSType="Do you want to fix legacy BIOS, or both legacy BIOS and UEFI? (1-2) "
if /i "%BIOSType%"=="1" goto "SureBIOSType"
if /i "%BIOSType%"=="2" goto "SureBIOSType"
echo Invalid syntax!
goto "BIOSType"

:"SureBIOSType"
echo.
set SureBIOSType=
if /i "%BIOSType%"=="1" set /p SureBIOSType="Are you sure you are trying to fix legacy BIOS? (Yes/No) "
if /i "%BIOSType%"=="2" set /p SureBIOSType="Are you sure you are trying to fix both legacy BIOS and UEFI? (Yes/No) "
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
set /p Partition="What is the partition number of the boot partition? If there is no boot partition or boot partition needs to be recreated enter "Need boot partition" (0-?/Need boot partition) "
if /i "%Partition%"=="Need boot partition" goto "SurePartition"
goto "SureBootPartition"

:"DiskPartExistPartition"
set DiskPart=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
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
set /p SurePartition="Are you sure there is no boot partition or boot partition needs to be recreated? (Yes/No) "
if /i "%MBRGPT%"=="MBR" if /i "%SurePartition%"=="Yes" goto "ListPartition"
if /i "%MBRGPT%"=="GPT" if /i "%SurePartition%"=="Yes" goto "fsutil"
if /i "%SurePartition%"=="No" goto "Partition"
echo Invalid syntax!
goto "SurePartition"

:"fsutil"
if exist "fsutil.txt" goto "fsutilExist"
echo.
echo Getting disk %Disk% details.
"%windir%\System32\fsutil.exe" fsinfo sectorinfo \\.\PhysicalDrive%Disk% | "%windir%\System32\find.exe" /i /c "PhysicalBytesPerSectorForAtomicity :                    4096" > "fsutil.txt"
set /p fsutil=< "fsutil.txt"
echo Got disk %Disk% details.
del "fsutil.txt" /f /q > nul 2>&1
if /i "%fsutil%"=="True" goto "fsutilDone"
goto "ListPartition"

:"fsutilExist"
set fsutil=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "fsutil.txt" in order for this batch file to proceed. "fsutil.txt" is not a system file. "fsutil.txt" is located in the folder "%cd%". Press any key to continue when "fsutil.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "fsutil"

:"fsutilDone"
echo.
echo You can now rename or move the file back to "fsutil.txt". Press any key to continue.
pause > nul 2>&1
goto "ListPartition"

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
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="1" set /p DeletePartition="Enter partition number that needs to be deleted to make space for boot partition. Recommended size is 100 MB but you can try 100-350 MB if you need to. Enter "Done" if you are done deleting partitions. (0-?/Done) "
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="2" set /p DeletePartition="Enter partition number that needs to be deleted to make space for boot partition. Recommended size is 350 MB but you can try 100-350 MB if you need to. Enter "Done" if you are done deleting partitions. (0-?/Done) "
if /i "%MBRGPT%"=="GPT" if /i "%fsutil%"=="0" set /p DeletePartition="Enter partition number that needs to be deleted to make space for boot partition. Recommended size is 100 MB but you can try 100-350 MB if you need to. Enter "Done" if you are done deleting partitions. (0-?/Done) "
if /i "%MBRGPT%"=="GPT" if /i "%fsutil%"=="1" set /p DeletePartition="Enter partition number that needs to be deleted to make space for boot partition. Recommended size is 260 MB but you can try 100-350 MB if you need to. Enter "Done" if you are done deleting partitions. (0-?/Done) "
if /i "%DeletePartition%"=="Done" goto "NewPartition"
goto "SureDeletePartition"

:"DiskPartExistDeletePartition"
set DiskPart=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
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
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
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
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="1"  set /p Size="Please enter boot partition size to create. Recommended size is 100 MB but you can try 100-350 MB if you need to. (100-350) "
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="2" set /p Size="Please enter boot partition size to create. Recommended size is 350 MB but you can try 100-350 MB if you need to. (100-350) "
if /i "%MBRGPT%"=="GPT" if /i "%fsutil%"=="0" set /p Size="Please enter boot partition size to create. Recommended size is 100 MB but you can try 100-350 MB if you need to. (100-350) "
if /i "%MBRGPT%"=="GPT" if /i "%fsutil%"=="1" set /p Size="Please enter boot partition size to create. Recommended size is 260 MB but you can try 100-350 MB if you need to. (100-350) "
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="1" if /i "%Size%"=="" set Size=100
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="2" if /i "%Size%"=="" set Size=350
if /i "%MBRGPT%"=="GPT" if /i "%fsutil%"=="0" if /i "%Size%"=="" set Size=100
if /i "%MBRGPT%"=="GPT" if /i "%fsutil%"=="1" if /i "%Size%"=="" set Size=260
if /i "%Size%"=="100" goto "SurePartitionSize"
if /i "%Size%"=="101" goto "SurePartitionSize"
if /i "%Size%"=="102" goto "SurePartitionSize"
if /i "%Size%"=="103" goto "SurePartitionSize"
if /i "%Size%"=="104" goto "SurePartitionSize"
if /i "%Size%"=="105" goto "SurePartitionSize"
if /i "%Size%"=="106" goto "SurePartitionSize"
if /i "%Size%"=="107" goto "SurePartitionSize"
if /i "%Size%"=="108" goto "SurePartitionSize"
if /i "%Size%"=="109" goto "SurePartitionSize"
if /i "%Size%"=="110" goto "SurePartitionSize"
if /i "%Size%"=="111" goto "SurePartitionSize"
if /i "%Size%"=="112" goto "SurePartitionSize"
if /i "%Size%"=="113" goto "SurePartitionSize"
if /i "%Size%"=="114" goto "SurePartitionSize"
if /i "%Size%"=="115" goto "SurePartitionSize"
if /i "%Size%"=="116" goto "SurePartitionSize"
if /i "%Size%"=="117" goto "SurePartitionSize"
if /i "%Size%"=="118" goto "SurePartitionSize"
if /i "%Size%"=="119" goto "SurePartitionSize"
if /i "%Size%"=="120" goto "SurePartitionSize"
if /i "%Size%"=="121" goto "SurePartitionSize"
if /i "%Size%"=="122" goto "SurePartitionSize"
if /i "%Size%"=="123" goto "SurePartitionSize"
if /i "%Size%"=="124" goto "SurePartitionSize"
if /i "%Size%"=="125" goto "SurePartitionSize"
if /i "%Size%"=="126" goto "SurePartitionSize"
if /i "%Size%"=="127" goto "SurePartitionSize"
if /i "%Size%"=="128" goto "SurePartitionSize"
if /i "%Size%"=="129" goto "SurePartitionSize"
if /i "%Size%"=="130" goto "SurePartitionSize"
if /i "%Size%"=="131" goto "SurePartitionSize"
if /i "%Size%"=="132" goto "SurePartitionSize"
if /i "%Size%"=="133" goto "SurePartitionSize"
if /i "%Size%"=="134" goto "SurePartitionSize"
if /i "%Size%"=="135" goto "SurePartitionSize"
if /i "%Size%"=="136" goto "SurePartitionSize"
if /i "%Size%"=="137" goto "SurePartitionSize"
if /i "%Size%"=="138" goto "SurePartitionSize"
if /i "%Size%"=="139" goto "SurePartitionSize"
if /i "%Size%"=="140" goto "SurePartitionSize"
if /i "%Size%"=="141" goto "SurePartitionSize"
if /i "%Size%"=="142" goto "SurePartitionSize"
if /i "%Size%"=="143" goto "SurePartitionSize"
if /i "%Size%"=="144" goto "SurePartitionSize"
if /i "%Size%"=="145" goto "SurePartitionSize"
if /i "%Size%"=="146" goto "SurePartitionSize"
if /i "%Size%"=="147" goto "SurePartitionSize"
if /i "%Size%"=="148" goto "SurePartitionSize"
if /i "%Size%"=="149" goto "SurePartitionSize"
if /i "%Size%"=="150" goto "SurePartitionSize"
if /i "%Size%"=="151" goto "SurePartitionSize"
if /i "%Size%"=="152" goto "SurePartitionSize"
if /i "%Size%"=="153" goto "SurePartitionSize"
if /i "%Size%"=="154" goto "SurePartitionSize"
if /i "%Size%"=="155" goto "SurePartitionSize"
if /i "%Size%"=="156" goto "SurePartitionSize"
if /i "%Size%"=="157" goto "SurePartitionSize"
if /i "%Size%"=="158" goto "SurePartitionSize"
if /i "%Size%"=="159" goto "SurePartitionSize"
if /i "%Size%"=="160" goto "SurePartitionSize"
if /i "%Size%"=="161" goto "SurePartitionSize"
if /i "%Size%"=="162" goto "SurePartitionSize"
if /i "%Size%"=="163" goto "SurePartitionSize"
if /i "%Size%"=="164" goto "SurePartitionSize"
if /i "%Size%"=="165" goto "SurePartitionSize"
if /i "%Size%"=="166" goto "SurePartitionSize"
if /i "%Size%"=="167" goto "SurePartitionSize"
if /i "%Size%"=="168" goto "SurePartitionSize"
if /i "%Size%"=="169" goto "SurePartitionSize"
if /i "%Size%"=="170" goto "SurePartitionSize"
if /i "%Size%"=="171" goto "SurePartitionSize"
if /i "%Size%"=="172" goto "SurePartitionSize"
if /i "%Size%"=="173" goto "SurePartitionSize"
if /i "%Size%"=="174" goto "SurePartitionSize"
if /i "%Size%"=="175" goto "SurePartitionSize"
if /i "%Size%"=="176" goto "SurePartitionSize"
if /i "%Size%"=="177" goto "SurePartitionSize"
if /i "%Size%"=="178" goto "SurePartitionSize"
if /i "%Size%"=="179" goto "SurePartitionSize"
if /i "%Size%"=="180" goto "SurePartitionSize"
if /i "%Size%"=="181" goto "SurePartitionSize"
if /i "%Size%"=="182" goto "SurePartitionSize"
if /i "%Size%"=="183" goto "SurePartitionSize"
if /i "%Size%"=="184" goto "SurePartitionSize"
if /i "%Size%"=="185" goto "SurePartitionSize"
if /i "%Size%"=="186" goto "SurePartitionSize"
if /i "%Size%"=="187" goto "SurePartitionSize"
if /i "%Size%"=="188" goto "SurePartitionSize"
if /i "%Size%"=="189" goto "SurePartitionSize"
if /i "%Size%"=="190" goto "SurePartitionSize"
if /i "%Size%"=="191" goto "SurePartitionSize"
if /i "%Size%"=="192" goto "SurePartitionSize"
if /i "%Size%"=="193" goto "SurePartitionSize"
if /i "%Size%"=="194" goto "SurePartitionSize"
if /i "%Size%"=="195" goto "SurePartitionSize"
if /i "%Size%"=="196" goto "SurePartitionSize"
if /i "%Size%"=="197" goto "SurePartitionSize"
if /i "%Size%"=="198" goto "SurePartitionSize"
if /i "%Size%"=="199" goto "SurePartitionSize"
if /i "%Size%"=="200" goto "SurePartitionSize"
if /i "%Size%"=="201" goto "SurePartitionSize"
if /i "%Size%"=="202" goto "SurePartitionSize"
if /i "%Size%"=="203" goto "SurePartitionSize"
if /i "%Size%"=="204" goto "SurePartitionSize"
if /i "%Size%"=="205" goto "SurePartitionSize"
if /i "%Size%"=="206" goto "SurePartitionSize"
if /i "%Size%"=="207" goto "SurePartitionSize"
if /i "%Size%"=="208" goto "SurePartitionSize"
if /i "%Size%"=="209" goto "SurePartitionSize"
if /i "%Size%"=="210" goto "SurePartitionSize"
if /i "%Size%"=="211" goto "SurePartitionSize"
if /i "%Size%"=="212" goto "SurePartitionSize"
if /i "%Size%"=="213" goto "SurePartitionSize"
if /i "%Size%"=="214" goto "SurePartitionSize"
if /i "%Size%"=="215" goto "SurePartitionSize"
if /i "%Size%"=="216" goto "SurePartitionSize"
if /i "%Size%"=="217" goto "SurePartitionSize"
if /i "%Size%"=="218" goto "SurePartitionSize"
if /i "%Size%"=="219" goto "SurePartitionSize"
if /i "%Size%"=="220" goto "SurePartitionSize"
if /i "%Size%"=="221" goto "SurePartitionSize"
if /i "%Size%"=="222" goto "SurePartitionSize"
if /i "%Size%"=="223" goto "SurePartitionSize"
if /i "%Size%"=="224" goto "SurePartitionSize"
if /i "%Size%"=="225" goto "SurePartitionSize"
if /i "%Size%"=="226" goto "SurePartitionSize"
if /i "%Size%"=="227" goto "SurePartitionSize"
if /i "%Size%"=="228" goto "SurePartitionSize"
if /i "%Size%"=="229" goto "SurePartitionSize"
if /i "%Size%"=="230" goto "SurePartitionSize"
if /i "%Size%"=="231" goto "SurePartitionSize"
if /i "%Size%"=="232" goto "SurePartitionSize"
if /i "%Size%"=="233" goto "SurePartitionSize"
if /i "%Size%"=="234" goto "SurePartitionSize"
if /i "%Size%"=="235" goto "SurePartitionSize"
if /i "%Size%"=="236" goto "SurePartitionSize"
if /i "%Size%"=="237" goto "SurePartitionSize"
if /i "%Size%"=="238" goto "SurePartitionSize"
if /i "%Size%"=="239" goto "SurePartitionSize"
if /i "%Size%"=="240" goto "SurePartitionSize"
if /i "%Size%"=="241" goto "SurePartitionSize"
if /i "%Size%"=="242" goto "SurePartitionSize"
if /i "%Size%"=="243" goto "SurePartitionSize"
if /i "%Size%"=="244" goto "SurePartitionSize"
if /i "%Size%"=="245" goto "SurePartitionSize"
if /i "%Size%"=="246" goto "SurePartitionSize"
if /i "%Size%"=="247" goto "SurePartitionSize"
if /i "%Size%"=="248" goto "SurePartitionSize"
if /i "%Size%"=="249" goto "SurePartitionSize"
if /i "%Size%"=="250" goto "SurePartitionSize"
if /i "%Size%"=="251" goto "SurePartitionSize"
if /i "%Size%"=="252" goto "SurePartitionSize"
if /i "%Size%"=="253" goto "SurePartitionSize"
if /i "%Size%"=="254" goto "SurePartitionSize"
if /i "%Size%"=="255" goto "SurePartitionSize"
if /i "%Size%"=="256" goto "SurePartitionSize"
if /i "%Size%"=="257" goto "SurePartitionSize"
if /i "%Size%"=="258" goto "SurePartitionSize"
if /i "%Size%"=="259" goto "SurePartitionSize"
if /i "%Size%"=="260" goto "SurePartitionSize"
if /i "%Size%"=="261" goto "SurePartitionSize"
if /i "%Size%"=="262" goto "SurePartitionSize"
if /i "%Size%"=="263" goto "SurePartitionSize"
if /i "%Size%"=="264" goto "SurePartitionSize"
if /i "%Size%"=="265" goto "SurePartitionSize"
if /i "%Size%"=="266" goto "SurePartitionSize"
if /i "%Size%"=="267" goto "SurePartitionSize"
if /i "%Size%"=="268" goto "SurePartitionSize"
if /i "%Size%"=="269" goto "SurePartitionSize"
if /i "%Size%"=="270" goto "SurePartitionSize"
if /i "%Size%"=="271" goto "SurePartitionSize"
if /i "%Size%"=="272" goto "SurePartitionSize"
if /i "%Size%"=="273" goto "SurePartitionSize"
if /i "%Size%"=="274" goto "SurePartitionSize"
if /i "%Size%"=="275" goto "SurePartitionSize"
if /i "%Size%"=="276" goto "SurePartitionSize"
if /i "%Size%"=="277" goto "SurePartitionSize"
if /i "%Size%"=="278" goto "SurePartitionSize"
if /i "%Size%"=="279" goto "SurePartitionSize"
if /i "%Size%"=="280" goto "SurePartitionSize"
if /i "%Size%"=="281" goto "SurePartitionSize"
if /i "%Size%"=="282" goto "SurePartitionSize"
if /i "%Size%"=="283" goto "SurePartitionSize"
if /i "%Size%"=="284" goto "SurePartitionSize"
if /i "%Size%"=="285" goto "SurePartitionSize"
if /i "%Size%"=="286" goto "SurePartitionSize"
if /i "%Size%"=="287" goto "SurePartitionSize"
if /i "%Size%"=="288" goto "SurePartitionSize"
if /i "%Size%"=="289" goto "SurePartitionSize"
if /i "%Size%"=="290" goto "SurePartitionSize"
if /i "%Size%"=="291" goto "SurePartitionSize"
if /i "%Size%"=="292" goto "SurePartitionSize"
if /i "%Size%"=="293" goto "SurePartitionSize"
if /i "%Size%"=="294" goto "SurePartitionSize"
if /i "%Size%"=="295" goto "SurePartitionSize"
if /i "%Size%"=="296" goto "SurePartitionSize"
if /i "%Size%"=="297" goto "SurePartitionSize"
if /i "%Size%"=="298" goto "SurePartitionSize"
if /i "%Size%"=="299" goto "SurePartitionSize"
if /i "%Size%"=="300" goto "SurePartitionSize"
if /i "%Size%"=="301" goto "SurePartitionSize"
if /i "%Size%"=="302" goto "SurePartitionSize"
if /i "%Size%"=="303" goto "SurePartitionSize"
if /i "%Size%"=="304" goto "SurePartitionSize"
if /i "%Size%"=="305" goto "SurePartitionSize"
if /i "%Size%"=="306" goto "SurePartitionSize"
if /i "%Size%"=="307" goto "SurePartitionSize"
if /i "%Size%"=="308" goto "SurePartitionSize"
if /i "%Size%"=="309" goto "SurePartitionSize"
if /i "%Size%"=="310" goto "SurePartitionSize"
if /i "%Size%"=="311" goto "SurePartitionSize"
if /i "%Size%"=="312" goto "SurePartitionSize"
if /i "%Size%"=="313" goto "SurePartitionSize"
if /i "%Size%"=="314" goto "SurePartitionSize"
if /i "%Size%"=="315" goto "SurePartitionSize"
if /i "%Size%"=="316" goto "SurePartitionSize"
if /i "%Size%"=="317" goto "SurePartitionSize"
if /i "%Size%"=="318" goto "SurePartitionSize"
if /i "%Size%"=="319" goto "SurePartitionSize"
if /i "%Size%"=="320" goto "SurePartitionSize"
if /i "%Size%"=="321" goto "SurePartitionSize"
if /i "%Size%"=="322" goto "SurePartitionSize"
if /i "%Size%"=="323" goto "SurePartitionSize"
if /i "%Size%"=="324" goto "SurePartitionSize"
if /i "%Size%"=="325" goto "SurePartitionSize"
if /i "%Size%"=="326" goto "SurePartitionSize"
if /i "%Size%"=="327" goto "SurePartitionSize"
if /i "%Size%"=="328" goto "SurePartitionSize"
if /i "%Size%"=="329" goto "SurePartitionSize"
if /i "%Size%"=="330" goto "SurePartitionSize"
if /i "%Size%"=="331" goto "SurePartitionSize"
if /i "%Size%"=="332" goto "SurePartitionSize"
if /i "%Size%"=="333" goto "SurePartitionSize"
if /i "%Size%"=="334" goto "SurePartitionSize"
if /i "%Size%"=="335" goto "SurePartitionSize"
if /i "%Size%"=="336" goto "SurePartitionSize"
if /i "%Size%"=="337" goto "SurePartitionSize"
if /i "%Size%"=="338" goto "SurePartitionSize"
if /i "%Size%"=="339" goto "SurePartitionSize"
if /i "%Size%"=="340" goto "SurePartitionSize"
if /i "%Size%"=="341" goto "SurePartitionSize"
if /i "%Size%"=="342" goto "SurePartitionSize"
if /i "%Size%"=="343" goto "SurePartitionSize"
if /i "%Size%"=="344" goto "SurePartitionSize"
if /i "%Size%"=="345" goto "SurePartitionSize"
if /i "%Size%"=="346" goto "SurePartitionSize"
if /i "%Size%"=="347" goto "SurePartitionSize"
if /i "%Size%"=="348" goto "SurePartitionSize"
if /i "%Size%"=="349" goto "SurePartitionSize"
if /i "%Size%"=="350" goto "SurePartitionSize"
echo Invalid syntax!
goto "NewPartition"

:"SurePartitionSize"
echo.
set SurePartitionSize=
set /p SurePartitionSize="Are you sure you want a boot partition size of %Size% MB? (Yes/No) "
if /i "%SurePartitionSize%"=="Yes" goto "CreatePartition"
if /i "%SurePartitionSize%"=="No" goto "NewPartition"
echo Invalid syntax!
goto "SurePartitionSize"

:"CreatePartition"
if exist "diskpart.txt" goto "DiskPartExistNewPartition"
echo.
echo Recreating boot partition.
(echo sel disk %Disk%) > "diskpart.txt"
if /i "%MBRGPT%"=="MBR" (echo create partition primary size=%Size%) >> "diskpart.txt"
if /i "%MBRGPT%"=="GPT" (echo create partition efi size=%Size%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "NewPartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo Boot partition recreated.
goto "Partition"

:"DiskPartExistNewPartition"
set DiskPart=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "NewPartition"

:"NewPartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! You can try again.
goto "NewPartition"

:"SureBootPartition"
echo.
set SurePartition=
set /p SurePartition="All data on partition %Partition% will be deleted! Are you sure partition %Partition% is the boot partition? (Yes/No) "
if /i "%SurePartition%"=="Yes" goto "BootloaderErrorWindowsErrorSet"
if /i "%SurePartition%"=="No" goto "Partition"
echo Invalid syntax!
goto "SureBootPartition"

:"BootloaderErrorWindowsErrorSet"
set BootloaderError=
set WindowsError=
goto "Volume1"

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
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
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
if /i "%BootloaderError%"=="True" if /i "%BootVolume%"=="%WindowsVolume%" if /i "%SureBootAsk1%"=="Yes" goto "SameBootWindows"
if /i "%SureBootAsk1%"=="Yes" goto "BootAsk2"
if /i "%SureBootAsk1%"=="No" goto "Volume1"
echo Invalid syntax!
goto "SureBootAsk1"

:"SameBootWindows"
echo Boot volume %BootVolume% is the same as Windows volume %WindowsVolume%! Please try again.
goto "Volume1"

:"BootAsk2"
echo.
set BootAsk2=
set /p BootAsk2="Is the boot volume %BootVolume% already assigned a drive letter? (Yes/No) "
if /i "%BootAsk2%"=="Yes" goto "SureBootAsk2"
if /i "%BootloaderError%"=="True" if /i "%BootAsk2%"=="No" goto "BootloaderDriveLetter"
if /i "%BootAsk2%"=="No" goto "Volume2"
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
if /i "%BootloaderError%"=="True" goto "AssignDriveLetterBootloader"
goto "Volume2"

:"DriveLetterBootloaderNotExist"
echo "%DriveLetterBootloader%" does not exist! Please try again.
goto "Volume1"

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
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
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
if /i "%BootVolume%"=="%WindowsVolume%" if /i "%SureWindowsAsk1%"=="Yes" goto "SameWindowsBoot"
if /i "%SureWindowsAsk1%"=="Yes" goto "WindowsAsk2"
if /i "%SureWindowsAsk1%"=="No" goto "Volume2"
echo Invalid syntax!
goto "SureWindowsAsk1"

:"SameWindowsBoot"
echo Windows volume %WindowsVolume% is the same as boot volume %BootVolume%! Please try again.
if /i "%WindowsError%"=="True" goto "Volume2"
goto "Volume1"

:"WindowsAsk2"
echo.
set WindowsAsk2=
set /p WindowsAsk2="Is the Windows volume %WindowsVolume% already assigned a drive letter? (Yes/No) "
if /i "%WindowsAsk2%"=="Yes" goto "SureWindowsAsk2"
if /i "%WindowsError%"=="True" if /i "%WindowsAsk2%"=="No" goto "WindowsDriveLetter" 
if /i "%BootAsk2%"=="Yes" if /i "%WindowsAsk2%"=="No" goto "WindowsDriveLetter"
if /i "%BootAsk2%"=="No" if /i "%WindowsAsk2%"=="No" goto "BootloaderDriveLetter"
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
if not exist "%DriveLetterWindows%\Windows" goto "NotWindows"
if /i "%WindowsError%"=="True" goto "AssignDriveLetterWindows"
if /i "%BootAsk2%"=="No" goto "BootloaderDriveLetter"
goto "AssignDriveLetterBootloader"

:"DriveLetterWindowsNotExist"
echo "%DriveLetterWindows%" does not exist! Please try again.
goto "Volume2"

:"NotWindows"
echo Windows not installed on "%DriveLetterWindows%"!
goto "Volume2"

:"WindowsDriveLetterSet"
set WindowsDriveLetter=
goto "BootloaderDriveLetter"

:"BootloaderDriveLetter"
if /i "%BootloaderError%"=="True" echo.
if /i "%BootloaderError%"=="True" echo Finding an available drive letter for the boot volume.
if /i not "%BootloaderError%"=="True" if /i "%WindowsAsk2%"=="Yes" echo.
if /i not "%BootloaderError%"=="True" if /i "%WindowsAsk2%"=="Yes" echo Finding an available drive letter for the boot volume.
if /i not "%BootloaderError%"=="True" if /i "%WindowsAsk2%"=="No" echo.
if /i not "%BootloaderError%"=="True" if /i "%WindowsAsk2%"=="No" echo Finding available drive letters for the boot and Windows volumes.
if not exist "A:" if /i not "%WindowsDriveLetter%"=="A:" set BootloaderDriveLetter=A:
if not exist "A:" if /i not "%WindowsDriveLetter%"=="A:" goto "AvailableDriveLetterFoundBootloader"
if not exist "B:" if /i not "%WindowsDriveLetter%"=="B:" set BootloaderDriveLetter=B:
if not exist "B:" if /i not "%WindowsDriveLetter%"=="B:" goto "AvailableDriveLetterFoundBootloader"
if not exist "C:" if /i not "%WindowsDriveLetter%"=="C:" set BootloaderDriveLetter=C:
if not exist "C:" if /i not "%WindowsDriveLetter%"=="C:" goto "AvailableDriveLetterFoundBootloader"
if not exist "D:" if /i not "%WindowsDriveLetter%"=="D:" set BootloaderDriveLetter=D:
if not exist "D:" if /i not "%WindowsDriveLetter%"=="D:" goto "AvailableDriveLetterFoundBootloader"
if not exist "E:" if /i not "%WindowsDriveLetter%"=="E:" set BootloaderDriveLetter=E:
if not exist "E:" if /i not "%WindowsDriveLetter%"=="E:" goto "AvailableDriveLetterFoundBootloader"
if not exist "F:" if /i not "%WindowsDriveLetter%"=="F:" set BootloaderDriveLetter=F:
if not exist "F:" if /i not "%WindowsDriveLetter%"=="F:" goto "AvailableDriveLetterFoundBootloader"
if not exist "G:" if /i not "%WindowsDriveLetter%"=="G:" set BootloaderDriveLetter=G:
if not exist "G:" if /i not "%WindowsDriveLetter%"=="G:" goto "AvailableDriveLetterFoundBootloader"
if not exist "H:" if /i not "%WindowsDriveLetter%"=="H:" set BootloaderDriveLetter=H:
if not exist "H:" if /i not "%WindowsDriveLetter%"=="H:" goto "AvailableDriveLetterFoundBootloader"
if not exist "I:" if /i not "%WindowsDriveLetter%"=="I:" set BootloaderDriveLetter=I:
if not exist "I:" if /i not "%WindowsDriveLetter%"=="I:" goto "AvailableDriveLetterFoundBootloader"
if not exist "J:" if /i not "%WindowsDriveLetter%"=="J:" set BootloaderDriveLetter=J:
if not exist "J:" if /i not "%WindowsDriveLetter%"=="J:" goto "AvailableDriveLetterFoundBootloader"
if not exist "K:" if /i not "%WindowsDriveLetter%"=="K:" set BootloaderDriveLetter=K:
if not exist "K:" if /i not "%WindowsDriveLetter%"=="K:" goto "AvailableDriveLetterFoundBootloader"
if not exist "L:" if /i not "%WindowsDriveLetter%"=="L:" set BootloaderDriveLetter=L:
if not exist "L:" if /i not "%WindowsDriveLetter%"=="L:" goto "AvailableDriveLetterFoundBootloader"
if not exist "M:" if /i not "%WindowsDriveLetter%"=="M:" set BootloaderDriveLetter=M:
if not exist "M:" if /i not "%WindowsDriveLetter%"=="M:" goto "AvailableDriveLetterFoundBootloader"
if not exist "N:" if /i not "%WindowsDriveLetter%"=="N:" set BootloaderDriveLetter=N:
if not exist "N:" if /i not "%WindowsDriveLetter%"=="N:" goto "AvailableDriveLetterFoundBootloader"
if not exist "O:" if /i not "%WindowsDriveLetter%"=="O:" set BootloaderDriveLetter=O:
if not exist "O:" if /i not "%WindowsDriveLetter%"=="O:" goto "AvailableDriveLetterFoundBootloader"
if not exist "P:" if /i not "%WindowsDriveLetter%"=="P:" set BootloaderDriveLetter=P:
if not exist "P:" if /i not "%WindowsDriveLetter%"=="P:" goto "AvailableDriveLetterFoundBootloader"
if not exist "Q:" if /i not "%WindowsDriveLetter%"=="Q:" set BootloaderDriveLetter=Q:
if not exist "Q:" if /i not "%WindowsDriveLetter%"=="Q:" goto "AvailableDriveLetterFoundBootloader"
if not exist "R:" if /i not "%WindowsDriveLetter%"=="R:" set BootloaderDriveLetter=R:
if not exist "R:" if /i not "%WindowsDriveLetter%"=="R:" goto "AvailableDriveLetterFoundBootloader"
if not exist "S:" if /i not "%WindowsDriveLetter%"=="S:" set BootloaderDriveLetter=S:
if not exist "S:" if /i not "%WindowsDriveLetter%"=="S:" goto "AvailableDriveLetterFoundBootloader"
if not exist "T:" if /i not "%WindowsDriveLetter%"=="T:" set BootloaderDriveLetter=T:
if not exist "T:" if /i not "%WindowsDriveLetter%"=="T:" goto "AvailableDriveLetterFoundBootloader"
if not exist "U:" if /i not "%WindowsDriveLetter%"=="U:" set BootloaderDriveLetter=U:
if not exist "U:" if /i not "%WindowsDriveLetter%"=="U:" goto "AvailableDriveLetterFoundBootloader"
if not exist "V:" if /i not "%WindowsDriveLetter%"=="V:" set BootloaderDriveLetter=V:
if not exist "V:" if /i not "%WindowsDriveLetter%"=="V:" goto "AvailableDriveLetterFoundBootloader"
if not exist "W:" if /i not "%WindowsDriveLetter%"=="W:" set BootloaderDriveLetter=W:
if not exist "W:" if /i not "%WindowsDriveLetter%"=="W:" goto "AvailableDriveLetterFoundBootloader"
if not exist "X:" if /i not "%WindowsDriveLetter%"=="X:" set BootloaderDriveLetter=X:
if not exist "X:" if /i not "%WindowsDriveLetter%"=="X:" goto "AvailableDriveLetterFoundBootloader"
if not exist "Y:" if /i not "%WindowsDriveLetter%"=="Y:" set BootloaderDriveLetter=Y:
if not exist "Y:" if /i not "%WindowsDriveLetter%"=="Y:" goto "AvailableDriveLetterFoundBootloader"
if not exist "Z:" if /i not "%WindowsDriveLetter%"=="Z:" set BootloaderDriveLetter=Z:
if not exist "Z:" if /i not "%WindowsDriveLetter%"=="Z:" goto "AvailableDriveLetterFoundBootloader"
echo No drive letters are available for the boot volume! Please unmount 1 drive and then press any key to try again.
if /i "%WindowsAsk2%"=="No" echo No drive letters are available for the boot and Windows volumes! Please unmount 2 drives and then press any key to try again.
pause > nul 2>&1
goto "BootloaderDriveLetter"

:"AvailableDriveLetterFoundBootloader"
if /i "%BootloaderError%"=="True" echo Found an available drive letter for the boot volume.
if /i not "%BootloaderError%"=="True" if /i "%WindowsAsk2%"=="Yes" echo Found an available drive letter for the boot volume.
if /i "%BootloaderError%"=="True" goto "AssignDriveLetterBootloader"
if /i "%WindowsAsk2%"=="Yes" goto "AssignDriveLetterBootloader"
if /i "%WindowsAsk2%"=="No" goto "WindowsDriveLetter"

:"WindowsDriveLetter"
if /i "%WindowsError%"=="True" echo.
if /i "%WindowsError%"=="True" echo Finding an available drive letter for the Windows volume.
if /i not "%WindowsError%"=="True" if /i "%BootAsk2%"=="Yes" echo.
if /i not "%WindowsError%"=="True" if /i "%BootAsk2%"=="Yes" echo Finding an available drive letter for the Windows volume.
if not exist "A:" if /i not "%BootloaderDriveLetter%"=="A:" set WindowsDriveLetter=A:
if not exist "A:" if /i not "%BootloaderDriveLetter%"=="A:" goto "AvailableDriveLetterFoundWindows"
if not exist "B:" if /i not "%BootloaderDriveLetter%"=="B:" set WindowsDriveLetter=B:
if not exist "B:" if /i not "%BootloaderDriveLetter%"=="B:" goto "AvailableDriveLetterFoundWindows"
if not exist "C:" if /i not "%BootloaderDriveLetter%"=="C:" set WindowsDriveLetter=C:
if not exist "C:" if /i not "%BootloaderDriveLetter%"=="C:" goto "AvailableDriveLetterFoundWindows"
if not exist "D:" if /i not "%BootloaderDriveLetter%"=="D:" set WindowsDriveLetter=D:
if not exist "D:" if /i not "%BootloaderDriveLetter%"=="D:" goto "AvailableDriveLetterFoundWindows"
if not exist "E:" if /i not "%BootloaderDriveLetter%"=="E:" set WindowsDriveLetter=E:
if not exist "E:" if /i not "%BootloaderDriveLetter%"=="E:" goto "AvailableDriveLetterFoundWindows"
if not exist "F:" if /i not "%BootloaderDriveLetter%"=="F:" set WindowsDriveLetter=F:
if not exist "F:" if /i not "%BootloaderDriveLetter%"=="F:" goto "AvailableDriveLetterFoundWindows"
if not exist "G:" if /i not "%BootloaderDriveLetter%"=="G:" set WindowsDriveLetter=G:
if not exist "G:" if /i not "%BootloaderDriveLetter%"=="G:" goto "AvailableDriveLetterFoundWindows"
if not exist "H:" if /i not "%BootloaderDriveLetter%"=="H:" set WindowsDriveLetter=H:
if not exist "H:" if /i not "%BootloaderDriveLetter%"=="H:" goto "AvailableDriveLetterFoundWindows"
if not exist "I:" if /i not "%BootloaderDriveLetter%"=="I:" set WindowsDriveLetter=I:
if not exist "I:" if /i not "%BootloaderDriveLetter%"=="I:" goto "AvailableDriveLetterFoundWindows"
if not exist "J:" if /i not "%BootloaderDriveLetter%"=="J:" set WindowsDriveLetter=J:
if not exist "J:" if /i not "%BootloaderDriveLetter%"=="J:" goto "AvailableDriveLetterFoundWindows"
if not exist "K:" if /i not "%BootloaderDriveLetter%"=="K:" set WindowsDriveLetter=K:
if not exist "K:" if /i not "%BootloaderDriveLetter%"=="K:" goto "AvailableDriveLetterFoundWindows"
if not exist "L:" if /i not "%BootloaderDriveLetter%"=="L:" set WindowsDriveLetter=L:
if not exist "L:" if /i not "%BootloaderDriveLetter%"=="L:" goto "AvailableDriveLetterFoundWindows"
if not exist "M:" if /i not "%BootloaderDriveLetter%"=="M:" set WindowsDriveLetter=M:
if not exist "M:" if /i not "%BootloaderDriveLetter%"=="M:" goto "AvailableDriveLetterFoundWindows"
if not exist "N:" if /i not "%BootloaderDriveLetter%"=="N:" set WindowsDriveLetter=N:
if not exist "N:" if /i not "%BootloaderDriveLetter%"=="N:" goto "AvailableDriveLetterFoundWindows"
if not exist "O:" if /i not "%BootloaderDriveLetter%"=="O:" set WindowsDriveLetter=O:
if not exist "O:" if /i not "%BootloaderDriveLetter%"=="O:" goto "AvailableDriveLetterFoundWindows"
if not exist "P:" if /i not "%BootloaderDriveLetter%"=="P:" set WindowsDriveLetter=P:
if not exist "P:" if /i not "%BootloaderDriveLetter%"=="P:" goto "AvailableDriveLetterFoundWindows"
if not exist "Q:" if /i not "%BootloaderDriveLetter%"=="Q:" set WindowsDriveLetter=Q:
if not exist "Q:" if /i not "%BootloaderDriveLetter%"=="Q:" goto "AvailableDriveLetterFoundWindows"
if not exist "R:" if /i not "%BootloaderDriveLetter%"=="R:" set WindowsDriveLetter=R:
if not exist "R:" if /i not "%BootloaderDriveLetter%"=="R:" goto "AvailableDriveLetterFoundWindows"
if not exist "S:" if /i not "%BootloaderDriveLetter%"=="S:" set WindowsDriveLetter=S:
if not exist "S:" if /i not "%BootloaderDriveLetter%"=="S:" goto "AvailableDriveLetterFoundWindows"
if not exist "T:" if /i not "%BootloaderDriveLetter%"=="T:" set WindowsDriveLetter=T:
if not exist "T:" if /i not "%BootloaderDriveLetter%"=="T:" goto "AvailableDriveLetterFoundWindows"
if not exist "U:" if /i not "%BootloaderDriveLetter%"=="U:" set WindowsDriveLetter=U:
if not exist "U:" if /i not "%BootloaderDriveLetter%"=="U:" goto "AvailableDriveLetterFoundWindows"
if not exist "V:" if /i not "%BootloaderDriveLetter%"=="V:" set WindowsDriveLetter=V:
if not exist "V:" if /i not "%BootloaderDriveLetter%"=="V:" goto "AvailableDriveLetterFoundWindows"
if not exist "W:" if /i not "%BootloaderDriveLetter%"=="W:" set WindowsDriveLetter=W:
if not exist "W:" if /i not "%BootloaderDriveLetter%"=="W:" goto "AvailableDriveLetterFoundWindows"
if not exist "X:" if /i not "%BootloaderDriveLetter%"=="X:" set WindowsDriveLetter=X:
if not exist "X:" if /i not "%BootloaderDriveLetter%"=="X:" goto "AvailableDriveLetterFoundWindows"
if not exist "Y:" if /i not "%BootloaderDriveLetter%"=="Y:" set WindowsDriveLetter=Y:
if not exist "Y:" if /i not "%BootloaderDriveLetter%"=="Y:" goto "AvailableDriveLetterFoundWindows"
if not exist "Z:" if /i not "%BootloaderDriveLetter%"=="Z:" set WindowsDriveLetter=Z:
if not exist "Z:" if /i not "%BootloaderDriveLetter%"=="Z:" goto "AvailableDriveLetterFoundWindows"
echo No drive letters are available for the Windows volume! Please unmount 1 drive and then press any key to try again.
pause > nul 2>&1
goto "WindowsDriveLetter"

:"AvailableDriveLetterFoundWindows"
if /i not "%WindowsError%"=="True" if /i "%BootAsk2%"=="Yes" echo Found an available drive letter for the Windows volume.
if /i not "%WindowsError%"=="True" if /i "%BootAsk2%"=="No" echo Found available drive letters for the boot and Windows volumes.
if /i "%WindowsError%"=="True" goto "AssignDriveLetterWindows"
goto "AssignDriveLetterBootloader"

:"AssignDriveLetterBootloader"
if exist "diskpart.txt" goto "DiskPartExistAssignDriveLetterBootloader"
echo.
if /i "%BootAsk2%"=="Yes" echo Formatting boot partition "%DriveLetterBootloader%".
if /i "%BootAsk2%"=="No" echo Assigning drive letter "%BootloaderDriveLetter%" to boot partition and formatting boot partition "%BootloaderDriveLetter%".
if /i "%BootAsk2%"=="No" (echo automount scrub) > "diskpart.txt"
if /i "%BootAsk2%"=="Yes" (echo sel vol %BootVolume%) > "diskpart.txt"
if /i "%BootAsk2%"=="No" (echo sel vol %BootVolume%) >> "diskpart.txt"
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="1" (echo format fs=ntfs label="System" quick) >> "diskpart.txt"
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="2" (echo format fs=fat32 label="System" quick) >> "diskpart.txt"
if /i "%MBRGPT%"=="GPT" (echo format fs=fat32 label="System" quick) >> "diskpart.txt"
if /i "%BootAsk2%"=="No" (echo assign letter=%BootloaderDriveLetter%) >> "diskpart.txt"
if /i "%MBRGPT%"=="MBR" (echo active) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "AssignDriveLetterBootloaderError"
del "diskpart.txt" /f /q > nul 2>&1
if /i "%BootAsk2%"=="Yes" echo Boot partition "%DriveLetterBootloader%" has been formatted.
if /i "%BootAsk2%"=="No" echo Drive letter "%BootloaderDriveLetter%" assigned to boot partition and boot partition "%BootloaderDriveLetter%" has been formatted.
if /i "%BootAsk2%"=="No" set DriveLetterBootloader=%BootloaderDriveLetter%
if /i "%WindowsAsk2%"=="Yes" goto "Bootloader"
if /i "%WindowsAsk2%"=="No" goto "AssignDriveLetterWindows"

:"DiskPartExistAssignDriveLetterBootloader"
set DiskPart=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "AssignDriveLetterBootloader"

:"AssignDriveLetterBootloaderError"
del "diskpart.txt" /f /q > nul 2>&1
set BootloaderError=True
echo There has been an error!
goto "Volume1"

:"AssignDriveLetterWindows"
if exist "diskpart.txt" goto "DiskPartExistAssignDriveLetterWindows"
echo.
echo Assigning Windows volume %WindowsVolume% drive letter "%WindowsDriveLetter%".
(echo automount scrub) > "diskpart.txt"
(echo sel vol %WindowsVolume%) >> "diskpart.txt"
(echo assign letter=%WindowsDriveLetter%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "AssignDriveLetterWindowsError"
del "diskpart.txt" /f /q > nul 2>&1
echo Assigned Windows volume %WindowsVolume% drive letter "%WindowsDriveLetter%".
set DriveLetterWindows=%WindowsDriveLetter%
goto "CheckExistDriveLetterWindowsAssign"

:"DiskPartExistAssignDriveLetterWindows"
set DiskPart=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "AssignDriveLetterWindows"

:"AssignDriveLetterWindowsError"
del "diskpart.txt" /f /q > nul 2>&1
set WindowsError=True
echo There has been an error!
goto "Volume2"

:"CheckExistDriveLetterWindowsAssign"
if not exist "%DriveLetterWindows%\Windows" goto "NotWindowsAssign"
goto "Bootloader"

:"NotWindowsAssign"
if exist "diskpart.txt" goto "DiskPartExistNotWindowsAssign"
echo.
echo Windows not installed on volume %WindowsVolume%! Removing drive letter "%DriveLetterWindows%" from volume %WindowsVolume%.
(echo sel vol %WindowsVolume%) > "diskpart.txt"
(echo remove letter=%DriveLetterWindows%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "NotWindowsAssignError"
del "diskpart.txt" /f /q > nul 2>&1
echo Removed drive letter "%DriveLetterWindows%" from volume %WindowsVolume%. Please try again.
set WindowsError=True
goto "Volume2"

:"DiskPartExistNotWindowsAssign"
set DiskPart=True
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "NotWindowsAssign"

:"NotWindowsAssignError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "NotWindowsAssign"

:"Bootloader"
echo.
echo Fixing the Windows bootloader.
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="1" "%windir%\System32\bcdboot.exe" "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f BIOS > nul 2>&1
if /i "%MBRGPT%"=="MBR" if /i "%BIOSType%"=="2" "%windir%\System32\bcdboot.exe" "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f ALL > nul 2>&1
if /i "%MBRGPT%"=="GPT" "%windir%\System32\bcdboot.exe" "%DriveLetterWindows%\Windows" /s "%DriveLetterBootloader%" /f UEFI > nul 2>&1
if not "%errorlevel%"=="0" goto "ErrorBootloader"
goto "RemoveDriveLetterBootloader"

:"ErrorBootloader"
echo There was an error and no new bootloader was created. You can try again.
goto "Disk"

:"RemoveDriveLetterBootloader"
if exist "diskpart.txt" goto "DiskPartExistRemoveDriveLetterBootloader"
echo.
echo Removing drive letter "%DriveLetterBootloader%" from boot partition.
(echo sel vol %BootVolume%) > "diskpart.txt"
(echo remove letter=%DriveLetterBootloader%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "RemoveDriveLetterBootloaderError"
del "diskpart.txt" /f /q > nul 2>&1
echo Removed drive letter "%DriveLetterBootloader%" from boot partition.
if /i "%DiskPart%"=="True" goto "DiskPartDone"
if /i "%PERE%"=="False" goto "DoneExit"
if /i "%PERE%"=="True" goto "DoneReboot"

:"DiskPartExistRemoveDriveLetterBootloader"
set DiskPart=True
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "RemoveDriveLetterBootloader"

:"RemoveDriveLetterBootloaderError"
del "diskpart.txt" /f /q > nul 2>&1
echo There has been an error! Press any key to try again.
pause > nul 2>&1
goto "RemoveDriveLetterBootloader"

:"DiskPartDone"
echo.
echo You can now rename or move the file back to "diskpart.txt".
if /i "%PERE%"=="False" goto "DoneExit"
if /i "%PERE%"=="True" goto "DoneReboot"

:"DoneExit"
endlocal
echo.
echo Your bootloader is fixed! Press any key to exit.
pause > nul 2>&1
exit

:"DoneReboot"
endlocal
echo.
echo Your bootloader is fixed! Please save everything you want before restarting this PC! Press any key to restart this PC.
pause > nul 2>&1
"%windir%\System32\wpeutil.exe" Reboot
exit
