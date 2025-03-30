@echo off
title Windows Bootloader Fixer
setlocal
echo Program Name: Windows Bootloader Fixer
echo Version: 4.2.19
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
set /p DeletePartition="Enter partition number that needs to be deleted to make space for boot partition. Recommended size is 350 MB but you can try to go down to 100 MB if you do not have the space. Enter "Done" if you are done deleting partitions. (0-?/Done) "
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
set /p Size="Please enter boot partition size to create. Recommended size is 350 MB but you can try to go down to 100 MB if you do not have the space. (100-350) "
if /i "%Size%"=="" set Size=350
if /i "%Size%"=="100" goto "CreatePartition"
if /i "%Size%"=="101" goto "CreatePartition"
if /i "%Size%"=="102" goto "CreatePartition"
if /i "%Size%"=="103" goto "CreatePartition"
if /i "%Size%"=="104" goto "CreatePartition"
if /i "%Size%"=="105" goto "CreatePartition"
if /i "%Size%"=="106" goto "CreatePartition"
if /i "%Size%"=="107" goto "CreatePartition"
if /i "%Size%"=="108" goto "CreatePartition"
if /i "%Size%"=="109" goto "CreatePartition"
if /i "%Size%"=="110" goto "CreatePartition"
if /i "%Size%"=="111" goto "CreatePartition"
if /i "%Size%"=="112" goto "CreatePartition"
if /i "%Size%"=="113" goto "CreatePartition"
if /i "%Size%"=="114" goto "CreatePartition"
if /i "%Size%"=="115" goto "CreatePartition"
if /i "%Size%"=="116" goto "CreatePartition"
if /i "%Size%"=="117" goto "CreatePartition"
if /i "%Size%"=="118" goto "CreatePartition"
if /i "%Size%"=="119" goto "CreatePartition"
if /i "%Size%"=="120" goto "CreatePartition"
if /i "%Size%"=="121" goto "CreatePartition"
if /i "%Size%"=="122" goto "CreatePartition"
if /i "%Size%"=="123" goto "CreatePartition"
if /i "%Size%"=="124" goto "CreatePartition"
if /i "%Size%"=="125" goto "CreatePartition"
if /i "%Size%"=="126" goto "CreatePartition"
if /i "%Size%"=="127" goto "CreatePartition"
if /i "%Size%"=="128" goto "CreatePartition"
if /i "%Size%"=="129" goto "CreatePartition"
if /i "%Size%"=="130" goto "CreatePartition"
if /i "%Size%"=="131" goto "CreatePartition"
if /i "%Size%"=="132" goto "CreatePartition"
if /i "%Size%"=="133" goto "CreatePartition"
if /i "%Size%"=="134" goto "CreatePartition"
if /i "%Size%"=="135" goto "CreatePartition"
if /i "%Size%"=="136" goto "CreatePartition"
if /i "%Size%"=="137" goto "CreatePartition"
if /i "%Size%"=="138" goto "CreatePartition"
if /i "%Size%"=="139" goto "CreatePartition"
if /i "%Size%"=="140" goto "CreatePartition"
if /i "%Size%"=="141" goto "CreatePartition"
if /i "%Size%"=="142" goto "CreatePartition"
if /i "%Size%"=="143" goto "CreatePartition"
if /i "%Size%"=="144" goto "CreatePartition"
if /i "%Size%"=="145" goto "CreatePartition"
if /i "%Size%"=="146" goto "CreatePartition"
if /i "%Size%"=="147" goto "CreatePartition"
if /i "%Size%"=="148" goto "CreatePartition"
if /i "%Size%"=="149" goto "CreatePartition"
if /i "%Size%"=="150" goto "CreatePartition"
if /i "%Size%"=="151" goto "CreatePartition"
if /i "%Size%"=="152" goto "CreatePartition"
if /i "%Size%"=="153" goto "CreatePartition"
if /i "%Size%"=="154" goto "CreatePartition"
if /i "%Size%"=="155" goto "CreatePartition"
if /i "%Size%"=="156" goto "CreatePartition"
if /i "%Size%"=="157" goto "CreatePartition"
if /i "%Size%"=="158" goto "CreatePartition"
if /i "%Size%"=="159" goto "CreatePartition"
if /i "%Size%"=="160" goto "CreatePartition"
if /i "%Size%"=="161" goto "CreatePartition"
if /i "%Size%"=="162" goto "CreatePartition"
if /i "%Size%"=="163" goto "CreatePartition"
if /i "%Size%"=="164" goto "CreatePartition"
if /i "%Size%"=="165" goto "CreatePartition"
if /i "%Size%"=="166" goto "CreatePartition"
if /i "%Size%"=="167" goto "CreatePartition"
if /i "%Size%"=="168" goto "CreatePartition"
if /i "%Size%"=="169" goto "CreatePartition"
if /i "%Size%"=="170" goto "CreatePartition"
if /i "%Size%"=="171" goto "CreatePartition"
if /i "%Size%"=="172" goto "CreatePartition"
if /i "%Size%"=="173" goto "CreatePartition"
if /i "%Size%"=="174" goto "CreatePartition"
if /i "%Size%"=="175" goto "CreatePartition"
if /i "%Size%"=="176" goto "CreatePartition"
if /i "%Size%"=="177" goto "CreatePartition"
if /i "%Size%"=="178" goto "CreatePartition"
if /i "%Size%"=="179" goto "CreatePartition"
if /i "%Size%"=="180" goto "CreatePartition"
if /i "%Size%"=="181" goto "CreatePartition"
if /i "%Size%"=="182" goto "CreatePartition"
if /i "%Size%"=="183" goto "CreatePartition"
if /i "%Size%"=="184" goto "CreatePartition"
if /i "%Size%"=="185" goto "CreatePartition"
if /i "%Size%"=="186" goto "CreatePartition"
if /i "%Size%"=="187" goto "CreatePartition"
if /i "%Size%"=="188" goto "CreatePartition"
if /i "%Size%"=="189" goto "CreatePartition"
if /i "%Size%"=="190" goto "CreatePartition"
if /i "%Size%"=="191" goto "CreatePartition"
if /i "%Size%"=="192" goto "CreatePartition"
if /i "%Size%"=="193" goto "CreatePartition"
if /i "%Size%"=="194" goto "CreatePartition"
if /i "%Size%"=="195" goto "CreatePartition"
if /i "%Size%"=="196" goto "CreatePartition"
if /i "%Size%"=="197" goto "CreatePartition"
if /i "%Size%"=="198" goto "CreatePartition"
if /i "%Size%"=="199" goto "CreatePartition"
if /i "%Size%"=="200" goto "CreatePartition"
if /i "%Size%"=="201" goto "CreatePartition"
if /i "%Size%"=="202" goto "CreatePartition"
if /i "%Size%"=="203" goto "CreatePartition"
if /i "%Size%"=="204" goto "CreatePartition"
if /i "%Size%"=="205" goto "CreatePartition"
if /i "%Size%"=="206" goto "CreatePartition"
if /i "%Size%"=="207" goto "CreatePartition"
if /i "%Size%"=="208" goto "CreatePartition"
if /i "%Size%"=="209" goto "CreatePartition"
if /i "%Size%"=="210" goto "CreatePartition"
if /i "%Size%"=="211" goto "CreatePartition"
if /i "%Size%"=="212" goto "CreatePartition"
if /i "%Size%"=="213" goto "CreatePartition"
if /i "%Size%"=="214" goto "CreatePartition"
if /i "%Size%"=="215" goto "CreatePartition"
if /i "%Size%"=="216" goto "CreatePartition"
if /i "%Size%"=="217" goto "CreatePartition"
if /i "%Size%"=="218" goto "CreatePartition"
if /i "%Size%"=="219" goto "CreatePartition"
if /i "%Size%"=="220" goto "CreatePartition"
if /i "%Size%"=="221" goto "CreatePartition"
if /i "%Size%"=="222" goto "CreatePartition"
if /i "%Size%"=="223" goto "CreatePartition"
if /i "%Size%"=="224" goto "CreatePartition"
if /i "%Size%"=="225" goto "CreatePartition"
if /i "%Size%"=="226" goto "CreatePartition"
if /i "%Size%"=="227" goto "CreatePartition"
if /i "%Size%"=="228" goto "CreatePartition"
if /i "%Size%"=="229" goto "CreatePartition"
if /i "%Size%"=="230" goto "CreatePartition"
if /i "%Size%"=="231" goto "CreatePartition"
if /i "%Size%"=="232" goto "CreatePartition"
if /i "%Size%"=="233" goto "CreatePartition"
if /i "%Size%"=="234" goto "CreatePartition"
if /i "%Size%"=="235" goto "CreatePartition"
if /i "%Size%"=="236" goto "CreatePartition"
if /i "%Size%"=="237" goto "CreatePartition"
if /i "%Size%"=="238" goto "CreatePartition"
if /i "%Size%"=="239" goto "CreatePartition"
if /i "%Size%"=="240" goto "CreatePartition"
if /i "%Size%"=="241" goto "CreatePartition"
if /i "%Size%"=="242" goto "CreatePartition"
if /i "%Size%"=="243" goto "CreatePartition"
if /i "%Size%"=="244" goto "CreatePartition"
if /i "%Size%"=="245" goto "CreatePartition"
if /i "%Size%"=="246" goto "CreatePartition"
if /i "%Size%"=="247" goto "CreatePartition"
if /i "%Size%"=="248" goto "CreatePartition"
if /i "%Size%"=="249" goto "CreatePartition"
if /i "%Size%"=="250" goto "CreatePartition"
if /i "%Size%"=="251" goto "CreatePartition"
if /i "%Size%"=="252" goto "CreatePartition"
if /i "%Size%"=="253" goto "CreatePartition"
if /i "%Size%"=="254" goto "CreatePartition"
if /i "%Size%"=="255" goto "CreatePartition"
if /i "%Size%"=="256" goto "CreatePartition"
if /i "%Size%"=="257" goto "CreatePartition"
if /i "%Size%"=="258" goto "CreatePartition"
if /i "%Size%"=="259" goto "CreatePartition"
if /i "%Size%"=="260" goto "CreatePartition"
if /i "%Size%"=="261" goto "CreatePartition"
if /i "%Size%"=="262" goto "CreatePartition"
if /i "%Size%"=="263" goto "CreatePartition"
if /i "%Size%"=="264" goto "CreatePartition"
if /i "%Size%"=="265" goto "CreatePartition"
if /i "%Size%"=="266" goto "CreatePartition"
if /i "%Size%"=="267" goto "CreatePartition"
if /i "%Size%"=="268" goto "CreatePartition"
if /i "%Size%"=="269" goto "CreatePartition"
if /i "%Size%"=="270" goto "CreatePartition"
if /i "%Size%"=="271" goto "CreatePartition"
if /i "%Size%"=="272" goto "CreatePartition"
if /i "%Size%"=="273" goto "CreatePartition"
if /i "%Size%"=="274" goto "CreatePartition"
if /i "%Size%"=="275" goto "CreatePartition"
if /i "%Size%"=="276" goto "CreatePartition"
if /i "%Size%"=="277" goto "CreatePartition"
if /i "%Size%"=="278" goto "CreatePartition"
if /i "%Size%"=="279" goto "CreatePartition"
if /i "%Size%"=="280" goto "CreatePartition"
if /i "%Size%"=="281" goto "CreatePartition"
if /i "%Size%"=="282" goto "CreatePartition"
if /i "%Size%"=="283" goto "CreatePartition"
if /i "%Size%"=="284" goto "CreatePartition"
if /i "%Size%"=="285" goto "CreatePartition"
if /i "%Size%"=="286" goto "CreatePartition"
if /i "%Size%"=="287" goto "CreatePartition"
if /i "%Size%"=="288" goto "CreatePartition"
if /i "%Size%"=="289" goto "CreatePartition"
if /i "%Size%"=="290" goto "CreatePartition"
if /i "%Size%"=="291" goto "CreatePartition"
if /i "%Size%"=="292" goto "CreatePartition"
if /i "%Size%"=="293" goto "CreatePartition"
if /i "%Size%"=="294" goto "CreatePartition"
if /i "%Size%"=="295" goto "CreatePartition"
if /i "%Size%"=="296" goto "CreatePartition"
if /i "%Size%"=="297" goto "CreatePartition"
if /i "%Size%"=="298" goto "CreatePartition"
if /i "%Size%"=="299" goto "CreatePartition"
if /i "%Size%"=="300" goto "CreatePartition"
if /i "%Size%"=="301" goto "CreatePartition"
if /i "%Size%"=="302" goto "CreatePartition"
if /i "%Size%"=="303" goto "CreatePartition"
if /i "%Size%"=="304" goto "CreatePartition"
if /i "%Size%"=="305" goto "CreatePartition"
if /i "%Size%"=="306" goto "CreatePartition"
if /i "%Size%"=="307" goto "CreatePartition"
if /i "%Size%"=="308" goto "CreatePartition"
if /i "%Size%"=="309" goto "CreatePartition"
if /i "%Size%"=="310" goto "CreatePartition"
if /i "%Size%"=="311" goto "CreatePartition"
if /i "%Size%"=="312" goto "CreatePartition"
if /i "%Size%"=="313" goto "CreatePartition"
if /i "%Size%"=="314" goto "CreatePartition"
if /i "%Size%"=="315" goto "CreatePartition"
if /i "%Size%"=="316" goto "CreatePartition"
if /i "%Size%"=="317" goto "CreatePartition"
if /i "%Size%"=="318" goto "CreatePartition"
if /i "%Size%"=="319" goto "CreatePartition"
if /i "%Size%"=="320" goto "CreatePartition"
if /i "%Size%"=="321" goto "CreatePartition"
if /i "%Size%"=="322" goto "CreatePartition"
if /i "%Size%"=="323" goto "CreatePartition"
if /i "%Size%"=="324" goto "CreatePartition"
if /i "%Size%"=="325" goto "CreatePartition"
if /i "%Size%"=="326" goto "CreatePartition"
if /i "%Size%"=="327" goto "CreatePartition"
if /i "%Size%"=="328" goto "CreatePartition"
if /i "%Size%"=="329" goto "CreatePartition"
if /i "%Size%"=="330" goto "CreatePartition"
if /i "%Size%"=="331" goto "CreatePartition"
if /i "%Size%"=="332" goto "CreatePartition"
if /i "%Size%"=="333" goto "CreatePartition"
if /i "%Size%"=="334" goto "CreatePartition"
if /i "%Size%"=="335" goto "CreatePartition"
if /i "%Size%"=="336" goto "CreatePartition"
if /i "%Size%"=="337" goto "CreatePartition"
if /i "%Size%"=="338" goto "CreatePartition"
if /i "%Size%"=="339" goto "CreatePartition"
if /i "%Size%"=="340" goto "CreatePartition"
if /i "%Size%"=="341" goto "CreatePartition"
if /i "%Size%"=="342" goto "CreatePartition"
if /i "%Size%"=="343" goto "CreatePartition"
if /i "%Size%"=="344" goto "CreatePartition"
if /i "%Size%"=="345" goto "CreatePartition"
if /i "%Size%"=="346" goto "CreatePartition"
if /i "%Size%"=="347" goto "CreatePartition"
if /i "%Size%"=="348" goto "CreatePartition"
if /i "%Size%"=="349" goto "CreatePartition"
if /i "%Size%"=="350" goto "CreatePartition"
echo Invalid syntax!
goto "NewPartition"

:"CreatePartition"
if exist "diskpart.txt" goto "DiskPartExistNewPartition"
echo.
echo Remaking boot partition.
(echo sel disk %Disk%) > "diskpart.txt"
if /i "%MBRGPT%"=="MBR" (echo create partition primary size=%Size%) >> "diskpart.txt"
if /i "%MBRGPT%"=="GPT" (echo create partition efi size=%Size%) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "NewPartitionError"
del "diskpart.txt" /f /q > nul 2>&1
echo Boot partition remade.
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
if /i "%SureBootAsk1%"=="Yes" goto "BootAsk2"
if /i "%SureBootAsk1%"=="No" goto "Volume1"
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
if /i "%BootloaderDriveLetter%"=="A:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="B:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="C:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="D:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="E:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="F:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="G:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="H:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="I:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="J:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="K:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="L:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="M:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="N:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="O:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="P:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="Q:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="R:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="S:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="T:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="U:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="V:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="W:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="X:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="Y:" goto "WindowsAsk1"
if /i "%BootloaderDriveLetter%"=="Z:" goto "WindowsAsk1"
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
goto "WindowsAsk1"

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
if /i "%BootloaderError%"=="True" goto "AssignDriveLetterBootloader"
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
if /i "%WindowsDriveLetter%"=="A:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="B:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="C:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="D:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="E:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="F:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="G:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="H:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="I:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="J:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="K:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="L:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="M:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="N:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="O:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="P:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="Q:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="R:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="S:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="U:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="V:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="W:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="X:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="Y:" goto "AssignDriveLetterBootloader"
if /i "%WindowsDriveLetter%"=="Z:" goto "AssignDriveLetterBootloader"
echo Invalid syntax!
goto "WindowsDriveLetter"

:"WindowsDriveLetterExist"
echo "%WindowsDriveLetter%" exists! Please try again.
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
if not exist "%DriveLetterWindows%\Windows" goto "NotWindows"
goto "AssignDriveLetterBootloader"

:"DriveLetterWindowsNotExist"
echo "%DriveLetterWindows%" does not exist! Please try again.
goto "Volume2"

:"NotWindows"
echo Windows not installed on "%DriveLetterWindows%"!
goto "Volume2"

:"AssignDriveLetterBootloader"
if /i "%WindowsError%"=="True" goto "AssignDriveLetterWindows"
if exist "diskpart.txt" goto "DiskPartExistAssignDriveLetterBootloader"
echo.
if /i "%BootAsk2%"=="No" echo Assigning drive letter "%BootloaderDriveLetter%" to boot partition and formatting boot partition.
if /i "%BootAsk2%"=="Yes" echo Formatting boot partition "%DriveLetterBootloader%".
(echo sel vol %BootVolume%) > "diskpart.txt"
(echo format fs=fat32 label="System" quick) >> "diskpart.txt"
if /i "%BootAsk2%"=="No" (echo assign letter=%BootloaderDriveLetter%) >> "diskpart.txt"
if /i "%MBRGPT%"=="MBR" (echo active) >> "diskpart.txt"
(echo exit) >> "diskpart.txt"
"%windir%\System32\diskpart.exe" /s "diskpart.txt" > nul 2>&1
if not "%errorlevel%"=="0" goto "AssignDriveLetterBootloaderError"
del "diskpart.txt" /f /q > nul 2>&1
if /i "%BootAsk2%"=="No" echo Drive letter "%BootloaderDriveLetter%" assigned to boot partition and boot partition "%BootloaderDriveLetter%" has been formatted.
if /i "%BootAsk2%"=="Yes" echo Boot partition "%DriveLetterBootloader%" has been formatted.
if /i "%BootAsk2%"=="No" set DriveLetterBootloader=%BootloaderDriveLetter%
if /i "%WindowsAsk%"=="No" goto "AssignDriveLetterWindows"
if /i "%WindowsAsk%"=="Yes" goto "Bootloader"

:"DiskPartExistAssignDriveLetterBootloader"
set DiskPart=True
echo.
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "AssignDriveLetterBootloader"

:"AssignDriveLetterBootloaderError"
del diskpart.txt /f /q > nul 2>&1
set BootloaderError=True
echo There has been an error!
goto "Volume1"

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
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
pause > nul 2>&1
goto "AssignDriveLetterWindows"

:"AssignDriveLetterWindowsError"
del "diskpart.txt" /f /q > nul 2>&1
set WindowsError=True
echo There has been an error!
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
echo Please temporarily rename to something else or temporarily move to another location "diskpart.txt" in order for this batch file to proceed. "diskpart.txt" is not a system file. "diskpart.txt" is located in the folder "%cd%". Press any key to continue when "diskpart.txt" is renamed to something else or moved to another location. This batch file will let you know when you can rename it back to its original name or move it back to its original location.
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
echo Your bootloader is fixed! Please save everything you want before restarting this PC! Press any key to restart this PC.
pause > nul 2>&1
"%windir%\System32\wpeutil.exe" Reboot
exit
