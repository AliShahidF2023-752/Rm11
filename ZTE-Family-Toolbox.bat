::This is a main script example. Follow the startup process in this example to complete the script startup.

::Standard setup, do not modify
@ECHO OFF
chcp 65001>nul
cd /d %~dp0
if exist bin (cd bin) else (ECHO.Cannot find bin. Please check if the tool is fully extracted and the script path is correct. & goto FATAL)

::Load configuration; custom config files can also be added below
if exist conf\fixed.bat (call conf\fixed) else (ECHO.Cannot find conf\fixed.bat & goto FATAL)
if exist conf\user.bat call conf\user
if not "%product%"=="" (if exist conf\dev-%product%.bat call conf\dev-%product%.bat)

::Load theme, do not modify
if "%framework_theme%"=="" set framework_theme=default
call framework theme %framework_theme%
COLOR %c_i%

::Custom window size, can be changed as needed
TITLE Tool starting...
mode con cols=71

::Check and obtain admin privileges; remove if not needed
if not exist tool\Win\gap.exe ECHO.Cannot find gap.exe. Please check if the tool is fully extracted and the script path is correct. & goto FATAL
tool\Win\gap.exe %0 || EXIT

::Startup preparation and checks, do not modify
call framework startpre
::call framework startpre skiptoolchk

::Startup complete. Write your script below
TITLE [No model selected] ZTE Family Toolbox %prog_ver% by KooAnn@SomeStealer [Free Forever, No Resale]
CLS
if "%product%"=="" goto SELDEV
if not exist conf\dev-%product%.bat goto SELDEV
goto MENU



:MENU
TITLE [%model%] ZTE Family Toolbox %prog_ver% by KooAnn@SomeStealer [Free Forever, No Resale]
if not exist res\%product%\bak md res\%product%\bak
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.ZTE Family Toolbox %prog_ver% by KooAnn@SomeStealer [Free Forever, No Resale]
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHOC {%c_w%}[%model%]{%c_i%} %cpu%{%c_i%}{\n}
ECHOC {%c_we%}If the model is incorrect, use the "Select Model" function first{%c_i%}{\n}
ECHO.
ECHO.
ECHO.^< WARNING: Rooting and flashing unofficial firmware requires BL unlock, otherwise device will be bricked! ^>
ECHO.
ECHO.0.Unlock BL           000.Lock BL (not recommended)
ECHO.1.Obtain Root         111.Root Recovery (won't boot)
ECHO.2.9008 Flash Full Package
ECHO.3.Flash Recovery (TWRP)
ECHO.4.Backup All Partitions (Backup ROM)
ECHO.
::ECHO.10.Nubia Temp Unlock  11.9008 Send Bootloader
::ECHO.11.9008 Send Bootloader
ECHO.14.adb Screen Mirror
ECHO.12.Flash Any Partition    13.Read Back Any Partition
::ECHO.         15.Temp Enter Full-Feature Fastboot
ECHO.16.View/Set Slot         17.Backup/Restore QCN
ECHO.18.Snapdragon 8E5 No-unlock BL+Preserve Fingerprint  19.Clear efisp partition (remove boot watermark)
ECHO.
ECHO.A.Open Backup Folder
ECHO.B.Select Model
ECHO.C.Check for Updates (Password: ebxn)
ECHO.D.Change Theme
ECHO.
ECHO.E.ZTE/Nubia/RedMagic Discussion & Feedback Group
ECHO.F.Firefly Flash Resource Site (Download 9008 packages, TWRP, etc.)
ECHO.G.About BFF
ECHO.
call input choice [0][000][1][111][2][3][4][12][13][14][16][17][18][19][A][B][C][D]#[E][F][G]
if "%choice%"=="0" goto UNLOCKBL
if "%choice%"=="000" goto LOCKBL
if "%choice%"=="1" goto ROOT
if "%choice%"=="111" goto ROOT-REC
if "%choice%"=="2" goto EDLFLASHFULL
if "%choice%"=="3" goto FLASHREC
if "%choice%"=="4" goto BAKALL
if "%choice%"=="10" goto NUBIAUNLOCK
if "%choice%"=="11" goto EDLSENDFH
if "%choice%"=="12" goto WRITEPAR
if "%choice%"=="13" goto READPAR
if "%choice%"=="14" call scrcpy ZTE-Family-Toolbox-adb-screenmirror
if "%choice%"=="15" goto ENTERDBGFB
if "%choice%"=="16" goto SLOT
if "%choice%"=="17" goto QCN
if "%choice%"=="18" goto 8E5CUSTOMIZEDBL
if "%choice%"=="19" goto CLEANEFISP
if "%choice%"=="A" call open folder res\%product%\bak
if "%choice%"=="B" goto SELDEV
if "%choice%"=="C" call open common https://syxz.lanzoue.com/b01g0i33c
if "%choice%"=="D" goto THEME
if "%choice%"=="E" start "" "https://yhfx.jwznb.com/share?key=BBmdd7wE9CNv&ts=1707895931 "
if "%choice%"=="F" call open common https://www.yhcres.top/
if "%choice%"=="G" call open common https://gitee.com/mouzei/bff
goto MENU







:CLEANEFISP
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Clear efisp Partition (Remove Boot Watermark)
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
if not "%blplan%"=="efisp" ECHO.%model% does not support this function. Press any key to return... & pause>nul & goto MENU
ECHO. [%model%]
ECHO.
ECHO.-Function Description:
ECHO. Small text on the first boot screen indicates a program running in the efisp partition
ECHO. Since most 9008 packages do not flash the efisp partition, this function is added separately
ECHO. The efisp partition is originally empty (no data); clearing it restores the original state
ECHO. Erasing via command may be ineffective; this function flashes an empty partition file for a complete clear
ECHO. After normal lock/unlock operations (except no-unlock method), the efisp program is not needed; recommended to clear
ECHO. Clearing means clearing partition content, not deleting the partition itself
ECHO. 
ECHOC {%c_h%}After reading the above, press any key to start...{%c_i%}{\n}& pause>nul
ECHOC {%c_h%}Please enter 9008 mode...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Clearing efisp... & call write qcedl efisp tool\Other\8e5gbl\efisp_empty.img %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.Rebooting... & call reboot qcedl system
ECHOC {%c_s%}Done. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:8E5CUSTOMIZEDBL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Snapdragon 8E5 No-Unlock BL + Preserve Fingerprint
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
if not "%blplan%"=="efisp" ECHO.%model% does not support this function. Press any key to return... & pause>nul & goto MENU
ECHO. [%model%]
ECHO.
ECHO.-Notes:
ECHO. Flashes a custom bootloader that boots from efisp instead of the official abl, enabling system modification without unlocking
ECHO. Based on the above, if efisp is cleared after using this function, it will stop working
ECHO. For BL-locked devices, you can flash third-party partitions (including Root) directly in locked state via 9008
ECHO. For BL-unlocked devices, system fingerprint will work after using this
ECHO. This function does not erase data, but it is still recommended to back up important data
ECHO. Some verification checks may not be removed; no-unlock third-party flashing is not guaranteed to boot
ECHO. To remove the no-unlock program, use the "Clear efisp Partition" function
ECHO.
ECHOC {%c_h%}After reading the above, press any key to start...{%c_i%}{\n}& pause>nul
ECHO.
ECHOC {%c_h%}Please enter 9008 mode...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Flashing no-unlock program... & call write qcedl efisp tool\Other\8e5gbl\gbl_superfastboot.efi %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.Rebooting... & call reboot qcedl system
ECHOC {%c_s%}Done. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:QCN
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Backup / Restore QCN
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. [%model%]
ECHO.
ECHO.QCN contains baseband, serial number info. This function is equivalent to QFIL QCN functions. Requires Root.
ECHO.
ECHO.1.Backup QCN   2.Restore QCN   A.Return to Main Menu
ECHO.
call input choice [1][2][A]
ECHO.
if "%choice%"=="A" goto MENU
if "%choice%"=="1" goto QCN-READ
if "%choice%"=="2" goto QCN-WRITE
EXIT
:QCN-READ
ECHOC {%c_h%}Please boot the device and enable USB debugging...{%c_i%}{\n}& call chkdev system rechk 1
ECHO.Enabling baseband diagnostic port... & call reboot system qcdiag rechk 1
for /f %%a in ('gettime.exe') do set baktime=%%a
ECHO.Backing up QCN to bin\res\%product%\bak\qcnbak_%baktime%.qcn . This may take a while, please wait... & call read qcdiag %chkdev__port__qcdiag% res\%product%\bak\qcnbak_%baktime%.qcn
goto QCN-DONE
:QCN-WRITE
ECHOC {%c_h%}Please select the QCN file to restore...{%c_i%}{\n}& call sel file s %framework_workspace%\res\%product%\bak [qcn]
ECHOC {%c_h%}Please boot the device and enable USB debugging...{%c_i%}{\n}& call chkdev system rechk 1
ECHO.Enabling baseband diagnostic port... & call reboot system qcdiag rechk 1
ECHO.Restoring QCN. This may take a while, please wait... & call write qcdiag %chkdev__port__qcdiag% %sel__file_path%
goto QCN-DONE
:QCN-DONE
ECHOC {%c_s%}Done. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:BAKALL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Backup All Partitions (Backup ROM)
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. [%model%]
ECHO.
ECHO.-Notes:
ECHO. This function backs up all device partitions (except userdata and last_parti) and the partition table
ECHO. The backup does not include user data
ECHO. After backup, an xml is auto-generated; use the "9008 Flash Full Package" function to flash it
ECHO. Full partition backup contains serial number, sensor data, etc.; it can only be used on the original device
ECHO. Timely full partition backup can prevent data loss to the greatest extent
ECHO.
ECHOC {%c_h%}After reading the above, press any key to start...{%c_i%}{\n}& pause>nul
ECHO.
ECHOC {%c_h%}Please select a save location...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
ECHOC {%c_h%}Please enter 9008 mode...{%c_i%}{\n}& call chkdev qcedl rechk 1
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
md %sel__folder_path%\ZTEToolBoxParBak_%baktime% 1>nul || ECHOC {%c_e%}Failed to create %sel__folder_path%\ZTEToolBoxParBak_%baktime%{%c_i%}{\n}&& goto FATAL
start framework logviewer start %logfile%
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.Reading back all partitions via 9008... & call ztetoolbox edlreadall %chkdev__port__qcedl% %sel__folder_path%\ZTEToolBoxParBak_%baktime%
ECHO.9008 full partition read-back complete. Rebooting phone... & call reboot qcedl system
call framework logviewer end
ECHOC {%c_s%}Done. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:SLOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.View / Set Slot
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. [%model%]
ECHO.
if "%parlayout%"=="aonly" ECHO.%model% does not need this function. Press any key to return... & pause>nul & goto MENU
set slot__a_unbootable=& set slot__b_unbootable=
ECHOC {%c_h%}Please put the device into System, Recovery, Fastboot, or 9008 mode...{%c_i%}{\n}& call chkdev all
::if not "%chkdev__mode%"=="system" (if not "%chkdev__mode%"=="recovery" (if not "%chkdev__mode%"=="fastboot" ECHOC {%c_e%}Mode error, please enter System, Recovery or Fastboot mode. {%c_h%}Press any key to retry...{%c_i%}{\n}& call log %logger% E Mode error:%chkdev__mode%.Should be in System, Recovery or Fastboot mode& pause>nul & ECHO.Retrying... & goto SLOT))
if "%chkdev__mode%"=="qcedl" ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port% %framework_workspace%\res\%product%\devprg auto
ECHO.Checking slot... & call slot %chkdev__mode% chk
ECHO.
    ECHOC {%c_i%}Current slot: %slot__cur%{%c_i%}
    if "%slot__cur_unbootable%"=="yes" ECHOC {%c_e%}(not bootable){%c_i%}
    ECHOC {%c_i%}   {%c_i%}
    ECHOC {%c_i%}Other slot: %slot__cur_oth%{%c_i%}
    if "%slot__cur_unbootable%"=="yes" ECHOC {%c_e%}(not bootable){%c_i%}
    ECHOC {%c_i%}{\n}
ECHO.
ECHO.A.Activate slot a   B.Activate slot b   C.Return to Main Menu
ECHO.
call input choice [A][B]#[C]
if "%choice%"=="A" set target=a
if "%choice%"=="B" set target=b
if "%choice%"=="C" goto MENU
ECHO.Setting slot to %target% ... & call slot %chkdev__mode% set %target%
if "%chkdev__mode%"=="qcedl" call reboot qcedl qcedl
goto SLOT


:FLASHREC
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Flash Recovery (TWRP)
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. [%model%]  Partition type: %parlayout%
ECHO.
ECHO.-Notes:
ECHO. BL lock must be unlocked to use this function
if not "%parlayout%"=="ab" ECHO. The official boot may automatically restore recovery to stock on boot. Rooting in advance can avoid this.
ECHO.
ECHO.1.Flash   2.Fastboot Temp Boot   3.Inject TWRP into boot (for devices without recovery partition)
ECHO.A.Download TWRP   B.Return to Main Menu
ECHO.
call input choice #[1][2][3][A][B]
if "%choice%"=="1" set func=flash
if "%choice%"=="2" set func=boot
if "%choice%"=="3" set func=recinst
if "%choice%"=="A" call open common https://yhcres.top/ & call open common https://twrp.me/Devices/ & goto FLASHREC
if "%choice%"=="B" goto MENU
ECHO.
goto FLASHREC-%func%
:FLASHREC-RECINST
if not "%parlayout%"=="ab" ECHO.%model% does not need this function. Press any key to return... & pause>nul & goto FLASHREC
ECHOC {%c_h%}Please select the TWRP image file...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img]
set recpath=%sel__file_path%
ECHOC {%c_h%}Please select the boot image file...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img]
set bootpath=%sel__file_path%
ECHOC {%c_h%}Please select where to save the new boot file...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
ECHO.Injecting recovery... & call imgkit recinst %bootpath% %sel__folder_path%\boot_new.img %recpath%
ECHO.New boot is at %sel__folder_path%\boot_new.img.
goto FLASHREC-DONE
:FLASHREC-BOOT
ECHOC {%c_h%}Please select the TWRP image file...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img]
ECHOC {%c_h%}Please enter Fastboot mode...{%c_i%}{\n}& call chkdev fastboot
ECHO.Temp booting... & call write fastbootboot %sel__file_path%
goto FLASHREC-DONE
:FLASHREC-FLASH
ECHOC {%c_h%}Please select the TWRP image file...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [img]
ECHOC {%c_h%}Please boot the device and enable USB debugging...{%c_i%}{\n}& call chkdev system rechk 1
if not "%parlayout%"=="aonly" ECHO.Reading slot info... & call slot system chk
ECHO.Current slot: %slot__cur%
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto FLASHREC-FLASH-%parlayout%
:FLASHREC-FLASH-AONLY
ECHO.Backing up current recovery...
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
call read qcedl recovery res\%product%\bak\recovery_%baktime%.img notice %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.File backed up to bin\res\%product%\bak\recovery_%baktime%.img.
ECHO.Flashing recovery... & call write qcedl recovery %sel__file_path%
goto FLASHREC-FLASH-DONE
:FLASHREC-FLASH-AB_REC
ECHO.Backing up current recovery_%slot__cur%...
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
call read qcedl recovery_%slot__cur% res\%product%\bak\recovery_%slot__cur%_%baktime%.img notice %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.File backed up to bin\res\%product%\bak\recovery_%slot__cur%_%baktime%.img.
ECHO.Flashing recovery_%slot__cur%... & call write qcedl recovery_%slot__cur% %sel__file_path%
goto FLASHREC-FLASH-DONE
:FLASHREC-FLASH-AB
ECHO.Backing up current boot_%slot__cur%...
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
call read qcedl boot_%slot__cur% res\%product%\bak\boot_%slot__cur%_%baktime%.img notice %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.File backed up to bin\res\%product%\bak\boot_%slot__cur%_%baktime%.img.
ECHO.Injecting recovery... & call imgkit recinst %framework_workspace%\res\%product%\bak\boot_%slot__cur%_%baktime%.img %tmpdir%\boot_rec.img %sel__file_path% noprompt
ECHO.Flashing boot_%slot__cur%... & call write qcedl boot_%slot__cur% %tmpdir%\boot_rec.img
goto FLASHREC-FLASH-DONE
:FLASHREC-FLASH-DONE
ECHO.
ECHO.1.Reboot to Recovery   2.Do not reboot
call input choice #[1][2]
if "%choice%"=="1" ECHO.Rebooting to Recovery... & call reboot qcedl recovery
goto FLASHREC-DONE
:FLASHREC-DONE
ECHO. & ECHOC {%c_s%}Done. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto FLASHREC


:NUBIAUNLOCK
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Nubia Temporary Unlock
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
if not "%product:~0,2%"=="NX" ECHO.%model% does not need this function. Press any key to return... & pause>nul & goto MENU
ECHOC {%c_h%}Please enter Fastboot mode...{%c_i%}{\n}& call chkdev fastboot
ECHO.fastboot.exe oem nubia_unlock NUBIA_%product% & ECHO.
fastboot.exe oem nubia_unlock NUBIA_%product%
ECHO. & ECHO.Done. Press any key to return... & pause>nul & goto MENU


:READPAR
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Read Back Any Partition
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Can be used in System (requires Root), TWRP, or 9008 mode
ECHO.Type exit to return to main menu
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHOC {%c_h%}Please select where to save the read-back files...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
ECHO.
:READPAR-1
ECHOC {%c_i%}=--------------------------------------------------------------------={%c_i%}{\n}
if not "%parname%"=="" ECHO.Last: %parname%
ECHOC {%c_h%}Partition name: {%c_i%}& set /p parname=
if "%parname%"=="" goto READPAR-1
if "%parname%"=="exit" goto MENU
:READPAR-2
call chkdev all
ECHO.Reading back... & call read %chkdev__mode% %parname% %sel__folder_path%\%parname%.img notice %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%chkdev__mode%"=="qcedl" call reboot qcedl qcedl
ECHOC {%c_s%}Read-back complete{%c_i%}{\n}& goto READPAR-1


:WRITEPAR
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Flash Any Partition
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Can be used in System (requires Root), TWRP, Fastboot, or 9008 mode
ECHO.Type exit to return to main menu
ECHO.
:WRITEPAR-1
ECHOC {%c_i%}=--------------------------------------------------------------------={%c_i%}{\n}
if not "%parname%"=="" ECHO.Last: %parname%
ECHOC {%c_h%}Partition name: {%c_i%}& set /p parname=
if "%parname%"=="" goto WRITEPAR-1
if "%parname%"=="exit" goto MENU
if "%imgfolder%"=="" set imgfolder=%framework_workspace%\..
ECHOC {%c_h%}Please select the %parname% partition file...{%c_i%}{\n}& call sel file s %imgfolder%
set imgfolder=%sel__file_folder%
:WRITEPAR-2
call chkdev all
ECHO.Flashing... & call write %chkdev__mode% %parname% %sel__file_path% %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%chkdev__mode%"=="qcedl" call reboot qcedl qcedl
ECHOC {%c_s%}Flash complete{%c_i%}{\n}& goto WRITEPAR-1


:EDLFLASHFULL
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.9008 Flash Full Package
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. [%model%]  Partition type: %parlayout%
ECHO.
if not exist %framework_workspace%\res\%product%\devprg\prog_firehose_ddr.elf ECHO.Note: This function is no longer maintained. Recommend using the [FlashBox] GUI tool for 9008 flashing. & ECHO.Download: gitee.com/geekflashtool & ECHO.
ECHO.-Notes
ECHO. This function is equivalent to QFIL's 9008 function
ECHO. The 9008 package must be extracted before use
ECHO. Back up all personal data before flashing
ECHO. Before flashing: disable Find My Device, delete fingerprints, remove lock screen password, sign out of accounts
ECHO. If official 9008 flashing fails, try deleting userdata.img from the package, reopen the tool and try again
ECHO. If the device won't boot after flashing, try factory reset
ECHO.
ECHOC {%c_h%}Press any key to start...{%c_i%}{\n}& pause>nul
ECHO.
set alreadypreedl=n
:EDLFLASHFULL-1
ECHOC {%c_h%}Please select the folder containing the 9008 package partition images and xml files...{%c_i%}{\n}& call sel folder s %framework_workspace%\..
if "%alreadypreedl%"=="y" goto EDLFLASHFULL-3
set fhpath=%framework_workspace%\res\%product%\devprg
if not exist %framework_workspace%\res\%product%\devprg ECHOC {%c_h%}Please select the bootloader file...{%c_i%}{\n}& call sel file s %sel__folder_path% [elf][mbn]
if not exist %framework_workspace%\res\%product%\devprg set fhpath=%sel__file_path%
ECHOC {%c_h%}Please enter 9008. If last flash failed, close the script, re-enter 9008, then start flashing again...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %fhpath%
ECHO.Reading device info... & call info qcedl %chkdev__port__qcedl%
ECHO.Storage type: %info__qcedl__memtype%
set alreadypreedl=y
:EDLFLASHFULL-3
ECHO.Checking files...
goto EDLFLASHFULL-%info__qcedl__memtype%
:EDLFLASHFULL-UFS
    if exist %sel__folder_path%\rawprogram0.xml (set xmls=rawprogram0.xml) else (goto EDLFLASHFULL-FILENOTFOUND)
    if exist %sel__folder_path%\patch0.xml set xmls=%xmls%/patch0.xml
    if exist %sel__folder_path%\rawprogram1.xml (set xmls=%xmls%/rawprogram1.xml) else (goto EDLFLASHFULL-FILENOTFOUND)
    if exist %sel__folder_path%\patch1.xml set xmls=%xmls%/patch1.xml
    if exist %sel__folder_path%\rawprogram2.xml (set xmls=%xmls%/rawprogram2.xml) else (goto EDLFLASHFULL-FILENOTFOUND)
    if exist %sel__folder_path%\patch2.xml set xmls=%xmls%/patch2.xml
    if exist %sel__folder_path%\rawprogram3.xml (set xmls=%xmls%/rawprogram3.xml) else (goto EDLFLASHFULL-FILENOTFOUND)
    if exist %sel__folder_path%\patch3.xml set xmls=%xmls%/patch3.xml
    if exist %sel__folder_path%\rawprogram4.xml (set xmls=%xmls%/rawprogram4.xml) else (goto EDLFLASHFULL-FILENOTFOUND)
    if exist %sel__folder_path%\patch4.xml set xmls=%xmls%/patch4.xml
    if exist %sel__folder_path%\rawprogram5.xml (set xmls=%xmls%/rawprogram5.xml) else (goto EDLFLASHFULL-FILENOTFOUND)
    if exist %sel__folder_path%\patch5.xml set xmls=%xmls%/patch5.xml
goto EDLFLASHFULL-2
:EDLFLASHFULL-EMMC
    if not exist %sel__folder_path%\rawprogram0.xml goto EDLFLASHFULL-FILENOTFOUND
    set xmls=rawprogram0.xml
    if exist %sel__folder_path%\patch0.xml set xmls=%xmls%/patch0.xml
goto EDLFLASHFULL-2
:EDLFLASHFULL-2
ECHO.Using the following xml: & ECHOC {%c_we%}%xmls%{%c_i%}{\n}
start framework logviewer start %logfile%
ECHO.Starting 9008 flash... & call write qcedlxml %chkdev__port__qcedl% %info__qcedl__memtype% %sel__folder_path% %xmls%
ECHO.setbootablestoragedrive... & call ztetoolbox edlsetbootablestoragedrive %chkdev__port__qcedl% %info__qcedl__memtype%
ECHO.Done.
call framework logviewer end
ECHO.
ECHO.1.Reboot (default)   2.Wipe data and reboot
call input choice #[1][2]
ECHO.
if "%choice%"=="2" ECHO.Flashing misc... & call write qcedl misc tool\Android\misc_wipedata.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
ECHO.
ECHOC {%c_s%}All done. {%c_i%}If device won't boot or system is abnormal, try entering official Recovery and clearing data manually. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU
:EDLFLASHFULL-FILENOTFOUND
ECHOC {%c_e%}The selected folder is missing required files (e.g. rawprogram0.xml). Check if the correct folder was selected. {%c_h%}Keep the device connected and press any key to reselect...{%c_i%}{\n}& pause>nul & goto EDLFLASHFULL-1


:ROOT-REC
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Root Recovery (Won't Boot)
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. [%model%]   Recovery plan: restore %bootpar%
ECHO.
ECHO.-Notes
ECHO. This function restores the auto-backed up %bootpar% when the device won't boot after Rooting with this toolbox.
if "%parlayout:~0,2%"=="ab" ECHO. Backup file will be flashed to both a and b slots.
ECHO.
ECHOC {%c_h%}Press any key to start...{%c_i%}{\n}& pause>nul
ECHO.
ECHOC {%c_h%}Please select the %bootpar% backup file to restore...{%c_i%}{\n}& call sel file s %framework_workspace%\res\%product%\bak [img]
ECHOC {%c_h%}Please manually enter 9008 mode...{%c_i%}{\n}& call chkdev qcedl rechk 1
if "%parlayout:~0,2%"=="ab" (
    ECHO.Flashing %bootpar%_a... & call write qcedl %bootpar%_a %sel__file_path% %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
    ECHO.Flashing %bootpar%_b... & call write qcedl %bootpar%_b %sel__file_path% %chkdev__port__qcedl%)
if not "%parlayout:~0,2%"=="ab" ECHO.Flashing %bootpar%... & call write qcedl %bootpar% %sel__file_path% %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.Rebooting... & call reboot qcedl system
ECHO.
ECHOC {%c_s%}All done. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:ROOT
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Obtain Root
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO. [%model%]   Root method: Magisk patch %bootpar%
ECHO.
ECHO.-Notes
ECHO. BL must be unlocked before Rooting
ECHO. This function currently only supports Magisk patching
ECHO. This function does not clear data and is not version-specific
ECHO. If already Rooted, use with caution to avoid Magisk version conflicts that may prevent booting
ECHO. To flash a different version of Magisk, first restore the stock %bootpar% partition
ECHO. If device won't boot after Root, use the Root Recovery function
ECHO.
ECHO.
ECHO.1.[Recommended] Use the built-in Magisk patch
ECHO.A.Select custom Magisk patch
ECHO.B.First-time Magisk installation FAQ
ECHO.C.Return to Main Menu
ECHO.
call input choice #[1][A][B][C]
ECHO.
if "%choice%"=="1" set zippath=..\Magisk29.0.apk
if "%choice%"=="A" ECHOC {%c_h%}Please select a Magisk zip or apk...{%c_i%}{\n}& call sel file s %framework_workspace%\.. [zip][apk]
if "%choice%"=="A" set zippath=%sel__file_path%
if "%choice%"=="B" call open pic pic\magiskqa.jpg & goto ROOT
if "%choice%"=="C" goto MENU
ECHOC {%c_h%}Please boot the device, connect to PC, and enable USB debugging...{%c_i%}{\n}& call chkdev system rechk 1
start framework logviewer start %logfile%
ECHO.Reading device info...
call info adb
call ztetoolbox chkproduct %info__adb__product%
if "%parlayout:~0,2%"=="ab" call slot system chk
if "%parlayout:~0,2%"=="ab" (set targetpar=%bootpar%_%slot__cur%) else (set targetpar=%bootpar%)
ECHOC {%c_we%}Device codename: %info__adb__product%{%c_i%}{\n}
ECHOC {%c_we%}Android version: %info__adb__androidver%{%c_i%}{\n}
ECHOC {%c_we%}Target partition: %targetpar%{%c_i%}{\n}
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
ECHO.Backing up %targetpar%...
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
call read qcedl %targetpar% res\%product%\bak\%targetpar%_%baktime%.img notice %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
ECHO.File backed up to bin\res\%product%\bak.
ECHO.Applying Magisk patch... & call imgkit magiskpatch %framework_workspace%\res\%product%\bak\%targetpar%_%baktime%.img %tmpdir%\boot_patched.img %zippath% noprompt
ECHO.Flashing %targetpar%... & call write qcedl %targetpar% %tmpdir%\boot_patched.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
call framework logviewer end
ECHO.
ECHOC {%c_s%}All done. {%c_h%}After booting, please install
if "%zippath%"=="..\Magisk29.0.apk" (ECHOC {%c_h%}Magisk29.0.apk from the toolbox directory. ) else (ECHOC {%c_h%}the appropriate Magisk APP. )
ECHOC {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:LOCKBL
set lockbl_chk=n
set lockbl_autoerase=n
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Lock Bootloader
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
if "%blplan%"=="n" ECHO.%model% does not support locking BL yet. Press any key to return... & pause>nul & goto MENU
if "%blplan%"=="special__P636A01" ECHO.%model% does not support locking BL yet. Press any key to return... & pause>nul & goto MENU
ECHO. [%model%]   Lock method: %blplan%
ECHO.
ECHO.-Locking BL may cause the following:
ECHO. All data will be wiped
ECHO. Device may not boot
ECHO. ...
ECHO.
ECHO.-BL locking requires the following preparation (all required):
ECHO. Fully restore the system to stock
ECHO. Install flash drivers
ECHO. Ensure the data cable connection is stable
ECHO. Remove lock screen password, disable Find My Device, sign out of official and Google accounts
ECHO. Back up all personal data to a location outside the device
ECHO. Close all flash-related software on the PC (e.g. phone assistants)
ECHO. Know how to enter 9008 mode
ECHO.
ECHO.-Locking BL is very dangerous. It is never recommended. Proceed at your own risk.
ECHO.
ECHO.
ECHOC {%c_h%}After reading the above, press any key to begin locking...{%c_i%}{\n}& pause>nul
ECHO.
:LOCKBL-1
ECHOC {%c_h%}Please boot the device, connect to PC, and enable USB debugging...{%c_i%}{\n}& call chkdev all rechk 1
if "%chkdev__mode%"=="system" goto LOCKBL-2
if "%blplan%"=="direct" (if not "%chkdev__mode%"=="fastboot" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto LOCKBL-1)
if "%blplan%"=="flashabl" (if not "%chkdev__mode%"=="qcedl" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto LOCKBL-1)
if "%blplan%"=="efisp" (if not "%chkdev__mode%"=="qcedl" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-1)
if "%blplan%"=="special__ailsa_ii" (if not "%chkdev__mode%"=="qcedl" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto LOCKBL-1)
ECHOC {%c_w%}Not recommended to start from %chkdev__mode%. Device info cannot be obtained correctly in %chkdev__mode% mode. Please boot the device, connect to PC, enable USB debugging, then press Enter.{%c_i%}{\n}
ECHO.1.[Recommended] Start from system   2.Start from %chkdev__mode%
call input choice #[1][2]
if "%choice%"=="1" goto LOCKBL-1
if "%parlayout:~0,2%"=="ab" set slot__cur=unknown
goto LOCKBL-%blplan%-START
goto FATAL
:LOCKBL-2
ECHO.Reading device info...
call info adb
call ztetoolbox chkproduct %info__adb__product%
if "%parlayout:~0,2%"=="ab" call slot system chk
ECHOC {%c_we%}Device codename: %info__adb__product%{%c_i%}{\n}
ECHOC {%c_we%}Android version: %info__adb__androidver%{%c_i%}{\n}
if "%parlayout:~0,2%"=="ab" ECHOC {%c_we%}Current slot: %slot__cur%{%c_i%}{\n}
goto LOCKBL-%blplan%
goto FATAL
:LOCKBL-AVB
if "%presskeytoedl%"=="y" (goto LOCKBL-AVB-PRESSKEYTOEDL) else (goto LOCKBL-AVB-CMDTOEDL)
:LOCKBL-AVB-PRESSKEYTOEDL
ECHOC {%c_h%}Hold down both volume up and volume down on the device, do not release, then press any key on PC to continue. Do not release until the script says so...{%c_i%}{\n}& pause>nul
ECHO.Rebooting... & adb.exe reboot 1>>%logfile% 2>&1 || ECHOC {%c_e%}Reboot failed. Keep the device connection stable. {%c_h%}Press any key to retry...{%c_i%}{\n}&& pause>nul && goto LOCKBL
ECHO.Note: The device should now be completely black. If the screen lights up, it has failed. Immediately disconnect the cable, close the script, and try again.
ECHOC {%c_h%}Keep holding both volume buttons...{%c_i%}{\n}
call chkdev qcedl rechk 1
ECHOC {%c_h%}You can release now{%c_i%}{\n}
goto LOCKBL-AVB-START
:LOCKBL-AVB-CMDTOEDL
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto LOCKBL-AVB-START
:LOCKBL-AVB-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%parlayout:~0,2%"=="ab" (if "%slot__cur%"=="unknown" ECHO.Checking current slot... & call slot qcedl chk)
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
if "%blplan_frp%"=="y" ECHO.Backing up frp... & call read qcedl frp res\%product%\bak\frp_%baktime%.img notice %chkdev__port__qcedl%
if "%storagetype%"=="ufs" (set targetlun=4) else (set targetlun=0)
if "%parlayout:~0,2%"=="ab" (set targetbootpar=boot_%slot__cur%& set targetvbmetapar=vbmeta_a& set targetpvmfwpar=pvmfw_%slot__cur%) else (set targetbootpar=boot& set targetvbmetapar=vbmeta& set targetpvmfwpar=pvmfw)
ECHO.Backing up gpt_main%targetlun%...
call partable readgpt qcedl %storagetype% %targetlun% gptmain res\%product%\bak\gpt_main%targetlun%.bin noprompt %chkdev__port__qcedl%
copy /Y res\%product%\bak\gpt_main%targetlun%.bin res\%product%\bak\gpt_main%targetlun%_%baktime%.bin 1>>%logfile% 2>&1 || goto FATAL
ECHO.Backing up %targetbootpar%...
call read qcedl %targetbootpar% res\%product%\bak\%targetbootpar%.img noprompt %chkdev__port__qcedl%
copy /Y res\%product%\bak\%targetbootpar%.img res\%product%\bak\%targetbootpar%_%baktime%.img 1>>%logfile% 2>&1 || goto FATAL
ECHO.File backed up to bin\res\%product%\bak.
ECHO.Modifying gpt_main%targetlun%...
copy /Y res\%product%\bak\gpt_main%targetlun%.bin %tmpdir%\tmp.bin 1>>%logfile% 2>&1 || goto FATAL
gpttool.exe -p %tmpdir%\tmp.bin -f rmpar:name:%targetvbmetapar% 1>>%logfile% 2>&1 || goto FATAL
gpttool.exe -p %tmpdir%\tmp.bin -f rmpar:name:%targetpvmfwpar%  1>>%logfile% 2>&1 || ECHOC {%c_we%}%targetpvmfwpar% partition not deleted...{%c_i%}{\n}&& call log %logger% W %targetpvmfwpar% partition not deleted
ECHO.Flashing gpt_main%targetlun%... & call partable writegpt qcedl %storagetype% %targetlun% %tmpdir%\tmp.bin %chkdev__port__qcedl%
ECHO.Flashing unlock uefi... & call write qcedl %targetbootpar% res\%product%\uefi_unlock.img %chkdev__port__qcedl%
if "%blplan_frp%"=="y" ECHO.Flashing unlock frp... & call write qcedl frp tool\Android\frp_unlock.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
ECHO.Device will enter Fastboot. If it does not auto-enter, do so manually. Then manually check Fastboot connection. Regardless of whether a connection is found, do not close the script; follow the prompts.
:LOCKBL-AVB-4
ECHO.1.Check Fastboot connection   2.Still not found after multiple checks   3.What is Fastboot?
call input choice #[1][2][3]
if "%choice%"=="2" ECHOC {%c_e%}Locking failed. Please join the feedback group.{%c_i%}{\n}& goto LOCKBL-AVB-1
if "%choice%"=="3" call open pic pic\fastboot.jpg & goto LOCKBL-AVB-4
fastboot.exe devices -l 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}Device not connected. {%c_i%}Check Device Manager, try reconnecting and check if drivers are installed.{%c_i%}{\n}&& goto LOCKBL-AVB-4
call chkdev fastboot
ECHO.Reading device info... & call info fastboot
if "%info__fastboot__unlocked%"=="no" ECHOC {%c_s%}Your device is now locked. {%c_i%}{\n}& set lockbl_chk=y& goto LOCKBL-AVB-1
ECHO.Executing lock command. If a prompt appears on the device, press volume keys to select "LOCK THE BOOTLOADER" (select the lower option if unclear), then press power to confirm. Device will reboot. Do not close the script.
fastboot.exe flashing lock 1>>%logfile% 2>&1 || ECHOC {%c_e%}Lock command failed. Please check the log.{%c_i%}{\n}
:LOCKBL-AVB-2
ECHO.1.I confirmed the lock   2.I did not see a lock confirmation prompt
call input choice [1][2]
if "%choice%"=="1" set lockbl_autoerase=y
if "%choice%"=="2" ECHOC {%c_e%}Locking failed. Please join the feedback group later.{%c_i%}{\n}
goto LOCKBL-AVB-1
:LOCKBL-AVB-1
ECHOC {%c_w%}This toolbox is made by KooAnn@SomeStealer, completely free, do not resell{%c_i%}{\n}
ECHOC {%c_i%}Device is in an abnormal state. The script will help restore it. Do not close the script; follow the prompts or bear the consequences. {%c_h%}No need to wait for boot. Manually enter 9008 now (see "How to Enter Each Mode" document in the toolbox folder)...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%blplan_frp%"=="y" ECHO.Restoring frp... & call write qcedl frp res\%product%\bak\frp_%baktime%.img %chkdev__port__qcedl%
ECHO.Restoring gpt_main%targetlun%... & call partable writegpt qcedl %storagetype% %targetlun% res\%product%\bak\gpt_main%targetlun%.bin %chkdev__port__qcedl%
ECHO.Restoring %targetbootpar%... & call write qcedl %targetbootpar% res\%product%\bak\%targetbootpar%.img %chkdev__port__qcedl%
if "%parlayout:~0,2%"=="ab" ECHO.Activating %slot__cur% slot... & call slot qcedl set %slot__cur%
if "%lockbl_autoerase%"=="y" ECHO.Setting auto factory reset... & call write qcedl misc tool\Android\misc_wipedata.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
goto LOCKBL-DONE
:LOCKBL-EFISP
if "%presskeytoedl%"=="y" (goto LOCKBL-EFISP-PRESSKEYTOEDL) else (goto LOCKBL-EFISP-CMDTOEDL)
:LOCKBL-EFISP-PRESSKEYTOEDL
ECHOC {%c_h%}Hold down both volume up and volume down on the device, do not release, then press any key on PC to continue. Do not release until the script says so...{%c_i%}{\n}& pause>nul
ECHO.Rebooting... & adb.exe reboot 1>>%logfile% 2>&1 || ECHOC {%c_e%}Reboot failed. Keep the device connection stable. {%c_h%}Press any key to retry...{%c_i%}{\n}&& pause>nul && goto LOCKBL
ECHO.Note: The device should now be completely black. If the screen lights up, it has failed. Immediately disconnect the cable, close the script, and try again.
ECHOC {%c_h%}Keep holding both volume buttons...{%c_i%}{\n}
call chkdev qcedl rechk 1
ECHOC {%c_h%}You can release now{%c_i%}{\n}
goto LOCKBL-EFISP-START
:LOCKBL-EFISP-CMDTOEDL
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto LOCKBL-EFISP-START
:LOCKBL-EFISP-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
::if "%blplan_frp%"=="y" ECHO.Backing up frp... & call read qcedl frp res\%product%\bak\frp_%baktime%.img notice %chkdev__port__qcedl%
ECHO.Backing up efisp... & call read qcedl efisp res\%product%\bak\efisp_%baktime%.img notice %chkdev__port__qcedl%
ECHO.File backed up to bin\res\%product%\bak.
ECHO.Flashing lock program... & call write qcedl efisp tool\Other\8e5gbl\gbl_lock.efi %chkdev__port__qcedl%
ECHO.Setting auto factory reset... & call write qcedl misc tool\Android\misc_wipedata.img %chkdev__port__qcedl%
::if "%blplan_frp%"=="y" ECHO.Flashing unlock frp... & call write qcedl frp tool\Android\frp_unlock.img %chkdev__port__qcedl%
ECHO.Rebooting (if it says failed, choose option 2)... & call reboot qcedl system
ECHO.If no yellow unlock warning appears after boot, locking was successful. Otherwise join the feedback group. Waiting 3 seconds... & TIMEOUT /T 3 /NOBREAK>nul
ECHOC {%c_w%}This toolbox is made by KooAnn@SomeStealer, completely free, do not resell{%c_i%}{\n}
ECHOC {%c_i%}Device is in an abnormal state. The script will help restore it. Do not close the script; follow the prompts or bear the consequences. {%c_h%}No need to wait for boot. Manually enter 9008 now (see "How to Enter Each Mode" document in the toolbox folder)...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
::if "%blplan_frp%"=="y" ECHO.Restoring frp... & call write qcedl frp res\%product%\bak\frp_%baktime%.img %chkdev__port__qcedl%
::ECHO.Restoring efisp... & call write qcedl efisp res\%product%\bak\efisp_%baktime%.img %chkdev__port__qcedl%
ECHO.Clearing efisp... & call write qcedl efisp tool\Other\8e5gbl\efisp_empty.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
goto LOCKBL-DONE
:LOCKBL-special__ailsa_ii
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto LOCKBL-special__ailsa_ii-START
:LOCKBL-special__ailsa_ii-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
ECHO.Backing up aboot... & call read qcedl aboot res\%product%\bak\aboot_%baktime%.mbn notice %chkdev__port__qcedl%
ECHO.Backing up fbop...  & call read qcedl fbop  res\%product%\bak\fbop_%baktime%.img  notice %chkdev__port__qcedl%
::ECHO.Backing up frp...   & call read qcedl frp   res\%product%\bak\frp_%baktime%.img   notice %chkdev__port__qcedl%
::ECHO.Patching frp to enable OEM unlock... & call imgkit patchfrp res\%product%\bak\frp_%baktime%.img %tmpdir%\frp_oemunlockon.img oemunlockon noprompt
ECHO.Flashing unlock aboot... & call write qcedl aboot res\%product%\aboot_unlock.mbn %chkdev__port__qcedl%
ECHO.Flashing unlock fbop...  & call write qcedl fbop  res\%product%\fbop_unlock.img  %chkdev__port__qcedl%
::ECHO.Flashing unlock frp...   & call write qcedl frp   %tmpdir%\frp_oemunlockon.img        %chkdev__port__qcedl%
ECHO.Rebooting to system... & call reboot qcedl system
ECHO.Device will automatically reboot. If USB debugging is not enabled after boot, enable it. If it won't boot, join the feedback group.
call chkdev system rechk 1
ECHO.Rebooting to Fastboot... & call reboot system fastboot rechk 1
ECHO.Executing lock command...
fastboot.exe oem lock 1>%tmpdir%\output.txt 2>&1 || ECHOC {%c_e%}Lock command failed. Please check the log.{%c_i%}{\n}
type %tmpdir%\output.txt>>%logfile%
find "Device already : locked!" "%tmpdir%\output.txt" 1>nul 2>nul && ECHOC {%c_s%}Your device is already locked.{%c_i%}{\n}&& set lockbl_chk=y&& goto LOCKBL-DONE
goto LOCKBL-DONE
:LOCKBL-FLASHABL
if "%presskeytoedl%"=="y" (goto LOCKBL-FLASHABL-PRESSKEYTOEDL) else (goto LOCKBL-FLASHABL-CMDTOEDL)
:LOCKBL-FLASHABL-PRESSKEYTOEDL
ECHOC {%c_h%}Hold down both volume up and volume down on the device, do not release, then press any key on PC to continue. Do not release until the script says so...{%c_i%}{\n}& pause>nul
ECHO.Rebooting... & adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%}Reboot failed. Keep the device connection stable. {%c_h%}Press any key to retry...{%c_i%}{\n}&& pause>nul && goto LOCKBL
ECHO.Note: The device should now be completely black. If the screen lights up, it has failed. Immediately disconnect the cable, close the script, and try again.
ECHOC {%c_h%}Keep holding both volume buttons...{%c_i%}{\n}
call chkdev qcedl rechk 1
ECHOC {%c_h%}You can release now{%c_i%}{\n}
goto LOCKBL-FLASHABL-START
:LOCKBL-FLASHABL-CMDTOEDL
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto LOCKBL-FLASHABL-START
:LOCKBL-FLASHABL-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
if "%blplan_frp%"=="y" ECHO.Backing up frp... & call read qcedl frp res\%product%\bak\frp_%baktime%.img notice %chkdev__port__qcedl%
if not "%parlayout:~0,2%"=="ab" (
    ECHO.Backing up abl... & call read qcedl abl res\%product%\bak\abl_%baktime%.elf notice %chkdev__port__qcedl%
    ECHO.File backed up to bin\res\%product%\bak.
    ECHO.Flashing unlock abl... & call write qcedl abl res\%product%\abl_unlock.elf %chkdev__port__qcedl%)
if "%parlayout:~0,2%"=="ab" (
    if "%slot__cur%"=="unknown" ECHO.Checking current slot... & call slot qcedl chk
    ECHO.Backing up abl_%slot__cur%... & call read qcedl abl_%slot__cur% res\%product%\bak\abl_%slot__cur%_%baktime%.elf notice %chkdev__port__qcedl%
    ECHO.File backed up to bin\res\%product%\bak.
    ECHO.Flashing unlock abl_%slot__cur%... & call write qcedl abl_%slot__cur% res\%product%\abl_unlock.elf %chkdev__port__qcedl%)
if "%blplan_frp%"=="y" ECHO.Flashing unlock frp... & call write qcedl frp tool\Android\frp_unlock.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
ECHO.Device will enter Fastboot. If it does not auto-enter, do so manually. Then manually check Fastboot connection. Regardless of whether a connection is found, do not close the script; follow the prompts.
:LOCKBL-FLASHABL-4
ECHO.1.Check Fastboot connection   2.Still not found after multiple checks   3.What is Fastboot?
call input choice #[1][2][3]
if "%choice%"=="2" ECHOC {%c_e%}Unlock failed. Please join the feedback group.{%c_i%}{\n}& goto LOCKBL-FLASHABL-1
if "%choice%"=="3" call open pic pic\fastboot.jpg & goto LOCKBL-FLASHABL-4
fastboot.exe devices -l 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}Device not connected. {%c_i%}Check Device Manager, try reconnecting, swap cables/ports, and check if drivers are installed.{%c_i%}{\n}&& goto LOCKBL-FLASHABL-4
call chkdev fastboot
ECHO.Reading device info... & call info fastboot
if "%info__fastboot__unlocked%"=="no" ECHOC {%c_s%}Your device is now locked. {%c_i%}{\n}& set lockbl_chk=y& goto LOCKBL-FLASHABL-1
ECHO.Executing lock command. If a prompt appears on the device, press volume keys to select "LOCK THE BOOTLOADER", then press power to confirm. Device will reboot. Do not close the script.
fastboot.exe flashing lock 1>>%logfile% 2>&1 || ECHOC {%c_e%}Lock command failed. Please check the log.{%c_i%}{\n}
:LOCKBL-FLASHABL-2
ECHO.1.I confirmed the lock   2.I did not see a lock confirmation prompt
call input choice [1][2]
::if "%choice%"=="3" call open pic pic\lockbl.jpg & goto LOCKBL-FLASHABL-2
if "%choice%"=="1" set lockbl_autoerase=y
if "%choice%"=="2" ECHOC {%c_e%}Locking failed. Please join the feedback group later.{%c_i%}{\n}
goto LOCKBL-FLASHABL-1
:LOCKBL-FLASHABL-1
ECHOC {%c_w%}This toolbox is made by KooAnn@SomeStealer, completely free, do not resell{%c_i%}{\n}
ECHOC {%c_i%}Device is in an abnormal state. The script will help restore it. Do not close the script; follow the prompts or bear the consequences. {%c_h%}No need to wait for boot. Manually enter 9008 now (see "How to Enter Each Mode" in the toolbox folder)...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%blplan_frp%"=="y" ECHO.Restoring frp... & call write qcedl frp res\%product%\bak\frp_%baktime%.img %chkdev__port__qcedl%
if not "%parlayout:~0,2%"=="ab" (
    ECHO.Restoring abl... & call write qcedl abl res\%product%\bak\abl_%baktime%.elf %chkdev__port__qcedl%)
if "%parlayout:~0,2%"=="ab" (
    ECHO.Restoring abl_%slot__cur%... & call write qcedl abl_%slot__cur% res\%product%\bak\abl_%slot__cur%_%baktime%.elf %chkdev__port__qcedl%
    ECHO.Activating %slot__cur% slot... & call slot qcedl set %slot__cur%)
if "%lockbl_autoerase%"=="y" ECHO.Setting auto factory reset... & call write qcedl misc tool\Android\misc_wipedata.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
goto LOCKBL-DONE
:LOCKBL-DIRECT
ECHO.Rebooting to fastboot... & call reboot system fastboot rechk 1
:LOCKBL-DIRECT-START
ECHO.Reading device info... & call info fastboot
if "%info__fastboot__unlocked%"=="no" ECHOC {%c_s%}Your device is now locked. {%c_i%}{\n}& set lockbl_chk=y& goto LOCKBL-DONE
ECHO.Executing lock command. If a prompt appears, press volume keys to select "LOCK THE BOOTLOADER", then press power to confirm. If no prompt, locking has failed.
fastboot.exe flashing lock 1>>%logfile% 2>&1 || ECHOC {%c_e%}Lock command failed. Please check the log.{%c_i%}{\n}
ECHO.1.I confirmed the lock   2.I did not see a lock confirmation prompt
call input choice [1][2]
if "%choice%"=="2" ECHOC {%c_e%}Locking failed. Please join the feedback group.{%c_i%}{\n}
goto LOCKBL-DONE
:LOCKBL-DONE
if "%lockbl_chk%"=="y" goto LOCKBL-DONE-1
::ECHO.
::ECHO.1.Check if locking was successful
::ECHO.2.I confirm locking was successful
::call input choice #[1][2]
::ECHO.
::if "%choice%"=="1" goto LOCKBL-1
:LOCKBL-DONE-1
ECHO. & ECHOC {%c_s%}All done. {%c_i%}If device won't boot after locking, enter Recovery and wipe all data for factory reset. First boot after factory reset may be slow. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:UNLOCKBL
set unlockbl_chk=n
set unlockbl_autoerase=n
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Unlock Bootloader
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
if "%blplan%"=="n" ECHO.%model% does not support BL unlocking yet. Press any key to return... & pause>nul & goto MENU
if "%blplan%"=="special__P636A01" ECHO.The BL unlock method for %model% is still under research. For Root and framework support, download the custom ROM from yhcres.top, flash via 9008, then factory reset. & ECHO. & ECHOC {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU
ECHO. [%model%]   Unlock method: %blplan%
ECHO.
::if "%blplan%"=="avb" ECHO.Unlock method source: github.com/atlas4381/qualcomm_avb_exploit_poc& ECHO.8Gen2 unlock files from KooAnn@Littlenine& ECHO.Unlock files may not be unpacked, modified, or abused& ECHO.
ECHO.-Unlocking BL may cause the following:
ECHO. System fingerprint unavailable (recalibration required; under-screen ultrasonic fingerprint may have no service calibration tool)
ECHO. TEE damage
ECHO. All data will be wiped
ECHO. Official system updates unavailable
ECHO. Loss of warranty
ECHO. Yellow unlock warning on boot
ECHO. Re-locking after unlocking is very dangerous
ECHO. ...
ECHO.
ECHO.-BL unlocking requires the following preparation (all required):
ECHO. Install flash drivers
ECHO. Ensure the data cable connection is stable
if "%product%"=="NX563J" ECHO. Download V6.28 9008 package from yhcres.top and flash it& ECHO. (Location: Flash Packages-Nubia-Nubia Z17-NubiaUI-9008 EDL Recovery Package)
if "%blplan_frp%"=="n" ECHO. Enable OEM unlock in developer options
ECHO. Remove lock screen password, disable Find My Device, sign out of official and Google accounts
ECHO. Back up all personal data to a location outside the device
ECHO. Close all flash-related software on the PC (e.g. phone assistants)
ECHO. Know how to enter 9008 mode
ECHO.
ECHO.-Follow the prompts strictly. Do not close mid-process if issues arise; take a screenshot and report to the feedback group.
ECHO.
ECHO.
ECHOC {%c_h%}After reading the above, press any key to begin unlocking...{%c_i%}{\n}& pause>nul
ECHO.
:UNLOCKBL-1
ECHOC {%c_h%}Please boot the device, connect to PC, and enable USB debugging...{%c_i%}{\n}& call chkdev all rechk 1
if "%chkdev__mode%"=="system" goto UNLOCKBL-2
if "%blplan%"=="direct" (if not "%chkdev__mode%"=="fastboot" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-1)
if "%blplan%"=="flashabl" (if not "%chkdev__mode%"=="qcedl" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-1)
if "%blplan%"=="efisp" (if not "%chkdev__mode%"=="qcedl" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-1)
if "%blplan%"=="avb" (if not "%chkdev__mode%"=="qcedl" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-1)
if "%blplan%"=="special__ailsa_ii" (if not "%chkdev__mode%"=="qcedl" ECHOC {%c_e%}Device mode error. {%c_h%}Press any key to retry...{%c_i%}{\n}& pause>nul & goto UNLOCKBL-1)
ECHOC {%c_w%}Not recommended to start from %chkdev__mode%. Device info cannot be obtained correctly in %chkdev__mode% mode. Please boot the device, connect to PC, enable USB debugging, then press Enter.{%c_i%}{\n}
ECHO.1.[Recommended] Start from system   2.Start from %chkdev__mode%
call input choice #[1][2]
if "%choice%"=="1" goto UNLOCKBL-1
if "%parlayout:~0,2%"=="ab" set slot__cur=unknown
goto UNLOCKBL-%blplan%-START
goto FATAL
:UNLOCKBL-2
ECHO.Reading device info...
call info adb
call ztetoolbox chkproduct %info__adb__product%
if "%parlayout:~0,2%"=="ab" call slot system chk
ECHOC {%c_we%}Device codename: %info__adb__product%{%c_i%}{\n}
ECHOC {%c_we%}Android version: %info__adb__androidver%{%c_i%}{\n}
if "%parlayout:~0,2%"=="ab" ECHOC {%c_we%}Current slot: %slot__cur%{%c_i%}{\n}
goto UNLOCKBL-%blplan%
goto FATAL
:UNLOCKBL-AVB
if "%presskeytoedl%"=="y" (goto UNLOCKBL-AVB-PRESSKEYTOEDL) else (goto UNLOCKBL-AVB-CMDTOEDL)
:UNLOCKBL-AVB-PRESSKEYTOEDL
ECHOC {%c_h%}Hold down both volume up and volume down on the device, do not release, then press any key on PC to continue. Do not release until the script says so...{%c_i%}{\n}& pause>nul
ECHO.Rebooting... & adb.exe reboot 1>>%logfile% 2>&1 || ECHOC {%c_e%}Reboot failed. Keep the device connection stable. {%c_h%}Press any key to retry...{%c_i%}{\n}&& pause>nul && goto UNLOCKBL
ECHO.Note: The device should now be completely black. If the screen lights up, it has failed. Immediately disconnect the cable, close the script, and try again.
ECHOC {%c_h%}Keep holding both volume buttons...{%c_i%}{\n}
call chkdev qcedl rechk 1
ECHOC {%c_h%}You can release now{%c_i%}{\n}
goto UNLOCKBL-AVB-START
:UNLOCKBL-AVB-CMDTOEDL
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto UNLOCKBL-AVB-START
:UNLOCKBL-AVB-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%parlayout:~0,2%"=="ab" (if "%slot__cur%"=="unknown" ECHO.Checking current slot... & call slot qcedl chk)
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
if "%blplan_frp%"=="y" ECHO.Backing up frp... & call read qcedl frp res\%product%\bak\frp_%baktime%.img notice %chkdev__port__qcedl%
if "%storagetype%"=="ufs" (set targetlun=4) else (set targetlun=0)
if "%parlayout:~0,2%"=="ab" (set targetbootpar=boot_%slot__cur%& set targetvbmetapar=vbmeta_a& set targetpvmfwpar=pvmfw_%slot__cur%) else (set targetbootpar=boot& set targetvbmetapar=vbmeta& set targetpvmfwpar=pvmfw)
ECHO.Backing up gpt_main%targetlun%...
call partable readgpt qcedl %storagetype% %targetlun% gptmain res\%product%\bak\gpt_main%targetlun%.bin noprompt %chkdev__port__qcedl%
copy /Y res\%product%\bak\gpt_main%targetlun%.bin res\%product%\bak\gpt_main%targetlun%_%baktime%.bin 1>>%logfile% 2>&1 || goto FATAL
ECHO.Backing up %targetbootpar%...
call read qcedl %targetbootpar% res\%product%\bak\%targetbootpar%.img noprompt %chkdev__port__qcedl%
copy /Y res\%product%\bak\%targetbootpar%.img res\%product%\bak\%targetbootpar%_%baktime%.img 1>>%logfile% 2>&1 || goto FATAL
ECHO.File backed up to bin\res\%product%\bak.
ECHO.Modifying gpt_main%targetlun%...
copy /Y res\%product%\bak\gpt_main%targetlun%.bin %tmpdir%\tmp.bin 1>>%logfile% 2>&1 || goto FATAL
gpttool.exe -p %tmpdir%\tmp.bin -f rmpar:name:%targetvbmetapar% 1>>%logfile% 2>&1 || goto FATAL
gpttool.exe -p %tmpdir%\tmp.bin -f rmpar:name:%targetpvmfwpar%  1>>%logfile% 2>&1 || ECHOC {%c_we%}%targetpvmfwpar% partition not deleted...{%c_i%}{\n}&& call log %logger% W %targetpvmfwpar% partition not deleted
ECHO.Flashing gpt_main%targetlun%... & call partable writegpt qcedl %storagetype% %targetlun% %tmpdir%\tmp.bin %chkdev__port__qcedl%
ECHO.Flashing unlock uefi... & call write qcedl %targetbootpar% res\%product%\uefi_unlock.img %chkdev__port__qcedl%
if "%blplan_frp%"=="y" ECHO.Flashing unlock frp... & call write qcedl frp tool\Android\frp_unlock.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
ECHO.Device will enter Fastboot. If it does not auto-enter, do so manually. Then manually check Fastboot connection. Regardless of whether a connection is found, do not close the script; follow the prompts.
:UNLOCKBL-AVB-4
ECHO.1.Check Fastboot connection   2.Still not found after multiple checks   3.What is Fastboot?
call input choice #[1][2][3]
if "%choice%"=="2" ECHOC {%c_e%}Unlocking failed. Please join the feedback group.{%c_i%}{\n}& goto UNLOCKBL-AVB-1
if "%choice%"=="3" call open pic pic\fastboot.jpg & goto UNLOCKBL-AVB-4
fastboot.exe devices -l 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}Device not connected. {%c_i%}Check Device Manager, try reconnecting, swap cables/ports, and check if drivers are installed.{%c_i%}{\n}&& goto UNLOCKBL-AVB-4
call chkdev fastboot
ECHO.Reading device info... & call info fastboot
if "%info__fastboot__unlocked%"=="yes" ECHOC {%c_s%}Your device is now unlocked. {%c_i%}{\n}& set unlockbl_chk=y& goto UNLOCKBL-AVB-1
ECHO.Executing unlock command. If a prompt appears, press volume keys to select "UNLOCK THE BOOTLOADER" (select the lower option if unclear), then press power to confirm. Device will reboot. Do not close the script.
fastboot.exe flashing unlock 1>>%logfile% 2>&1 || ECHOC {%c_e%}Unlock command failed. Please check the log.{%c_i%}{\n}
:UNLOCKBL-AVB-2
ECHO.1.I confirmed the unlock   2.I did not see an unlock confirmation prompt   3.What is the unlock prompt?
call input choice [1][2][3]
if "%choice%"=="3" call open pic pic\unlockbl.jpg & goto UNLOCKBL-AVB-2
if "%choice%"=="1" set unlockbl_autoerase=y
if "%choice%"=="2" ECHOC {%c_e%}Unlocking failed. Please join the feedback group later.{%c_i%}{\n}
goto UNLOCKBL-AVB-1
:UNLOCKBL-AVB-1
ECHOC {%c_w%}This toolbox is made by KooAnn@SomeStealer, completely free, do not resell{%c_i%}{\n}
ECHOC {%c_i%}Device is in an abnormal state. The script will help restore it. Do not close the script; follow the prompts or bear the consequences. {%c_h%}No need to wait for boot. Manually enter 9008 now (see "How to Enter Each Mode" document in the toolbox folder)...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%blplan_frp%"=="y" ECHO.Restoring frp... & call write qcedl frp res\%product%\bak\frp_%baktime%.img %chkdev__port__qcedl%
ECHO.Restoring gpt_main%targetlun%... & call partable writegpt qcedl %storagetype% %targetlun% res\%product%\bak\gpt_main%targetlun%.bin %chkdev__port__qcedl%
ECHO.Restoring %targetbootpar%... & call write qcedl %targetbootpar% res\%product%\bak\%targetbootpar%.img %chkdev__port__qcedl%
if "%parlayout:~0,2%"=="ab" ECHO.Activating %slot__cur% slot... & call slot qcedl set %slot__cur%
if "%unlockbl_autoerase%"=="y" ECHO.Setting auto factory reset... & call write qcedl misc tool\Android\misc_wipedata.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
goto UNLOCKBL-DONE
:UNLOCKBL-EFISP
if "%presskeytoedl%"=="y" (goto UNLOCKBL-EFISP-PRESSKEYTOEDL) else (goto UNLOCKBL-EFISP-CMDTOEDL)
:UNLOCKBL-EFISP-PRESSKEYTOEDL
ECHOC {%c_h%}Hold down both volume up and volume down on the device, do not release, then press any key on PC to continue. Do not release until the script says so...{%c_i%}{\n}& pause>nul
ECHO.Rebooting... & adb.exe reboot 1>>%logfile% 2>&1 || ECHOC {%c_e%}Reboot failed. Keep the device connection stable. {%c_h%}Press any key to retry...{%c_i%}{\n}&& pause>nul && goto UNLOCKBL
ECHO.Note: The device should now be completely black. If the screen lights up, it has failed. Immediately disconnect the cable, close the script, and try again.
ECHOC {%c_h%}Keep holding both volume buttons...{%c_i%}{\n}
call chkdev qcedl rechk 1
ECHOC {%c_h%}You can release now{%c_i%}{\n}
goto UNLOCKBL-EFISP-START
:UNLOCKBL-EFISP-CMDTOEDL
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto UNLOCKBL-EFISP-START
:UNLOCKBL-EFISP-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
::if "%blplan_frp%"=="y" ECHO.Backing up frp... & call read qcedl frp res\%product%\bak\frp_%baktime%.img notice %chkdev__port__qcedl%
ECHO.Backing up efisp... & call read qcedl efisp res\%product%\bak\efisp_%baktime%.img notice %chkdev__port__qcedl%
ECHO.File backed up to bin\res\%product%\bak.
ECHO.Flashing unlock program... & call write qcedl efisp tool\Other\8e5gbl\gbl_unlock.efi %chkdev__port__qcedl%
ECHO.Setting auto factory reset... & call write qcedl misc tool\Android\misc_wipedata.img %chkdev__port__qcedl%
::if "%blplan_frp%"=="y" ECHO.Flashing unlock frp... & call write qcedl frp tool\Android\frp_unlock.img %chkdev__port__qcedl%
ECHO.Rebooting (if it says failed, choose option 2)... & call reboot qcedl system
ECHO.A yellow unlock warning will appear during device boot.
:UNLOCKBL-EFISP-4
ECHO.1.I saw the unlock warning   2.I did not see the unlock warning   3.View example image
call input choice [1][2]#[3]
if "%choice%"=="2" ECHOC {%c_e%}Unlocking failed. Please join the feedback group.{%c_i%}{\n}& goto UNLOCKBL-EFISP-1
if "%choice%"=="3" call open pic pic\blunlockedfeatures.jpg & goto UNLOCKBL-EFISP-4
:UNLOCKBL-EFISP-1
ECHOC {%c_w%}This toolbox is made by KooAnn@SomeStealer, completely free, do not resell{%c_i%}{\n}
ECHOC {%c_i%}Device is in an abnormal state. The script will help restore it. Do not close the script; follow the prompts or bear the consequences. {%c_h%}No need to wait for boot. Manually enter 9008 now (see "How to Enter Each Mode" document in the toolbox folder)...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
::if "%blplan_frp%"=="y" ECHO.Restoring frp... & call write qcedl frp res\%product%\bak\frp_%baktime%.img %chkdev__port__qcedl%
::ECHO.Restoring efisp... & call write qcedl efisp res\%product%\bak\efisp_%baktime%.img %chkdev__port__qcedl%
ECHO.Clearing efisp... & call write qcedl efisp tool\Other\8e5gbl\efisp_empty.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
goto UNLOCKBL-DONE
:UNLOCKBL-FLASHABL
if "%presskeytoedl%"=="y" (goto UNLOCKBL-FLASHABL-PRESSKEYTOEDL) else (goto UNLOCKBL-FLASHABL-CMDTOEDL)
:UNLOCKBL-FLASHABL-PRESSKEYTOEDL
ECHOC {%c_h%}Hold down both volume up and volume down on the device, do not release, then press any key on PC to continue. Do not release until the script says so...{%c_i%}{\n}& pause>nul
ECHO.Rebooting... & adb.exe reboot bootloader 1>>%logfile% 2>&1 || ECHOC {%c_e%}Reboot failed. Keep the device connection stable. {%c_h%}Press any key to retry...{%c_i%}{\n}&& pause>nul && goto UNLOCKBL
ECHO.Note: The device should now be completely black. If the screen lights up, it has failed. Immediately disconnect the cable, close the script, and try again.
ECHOC {%c_h%}Keep holding both volume buttons...{%c_i%}{\n}
call chkdev qcedl rechk 1
ECHOC {%c_h%}You can release now{%c_i%}{\n}
goto UNLOCKBL-FLASHABL-START
:UNLOCKBL-FLASHABL-CMDTOEDL
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto UNLOCKBL-FLASHABL-START
:UNLOCKBL-FLASHABL-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
if "%blplan_frp%"=="y" ECHO.Backing up frp... & call read qcedl frp res\%product%\bak\frp_%baktime%.img notice %chkdev__port__qcedl%
if not "%parlayout:~0,2%"=="ab" (
    ECHO.Backing up abl... & call read qcedl abl res\%product%\bak\abl_%baktime%.elf notice %chkdev__port__qcedl%
    ECHO.File backed up to bin\res\%product%\bak.
    ECHO.Flashing unlock abl... & call write qcedl abl res\%product%\abl_unlock.elf %chkdev__port__qcedl%)
if "%parlayout:~0,2%"=="ab" (
    ::ECHO.Backing up lun4 partition table... & call partable qcedl readgpt %chkdev__port__qcedl% auto 4 main res\%product%\bak\gpt_main4_%baktime%.bin notice
    if "%slot__cur%"=="unknown" ECHO.Checking current slot... & call slot qcedl chk
    ECHO.Backing up abl_%slot__cur%... & call read qcedl abl_%slot__cur% res\%product%\bak\abl_%slot__cur%_%baktime%.elf notice %chkdev__port__qcedl%
    ECHO.File backed up to bin\res\%product%\bak.
    ECHO.Flashing unlock abl_%slot__cur%... & call write qcedl abl_%slot__cur% res\%product%\abl_unlock.elf %chkdev__port__qcedl%)
if "%blplan_frp%"=="y" ECHO.Flashing unlock frp... & call write qcedl frp tool\Android\frp_unlock.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
ECHO.Device will enter Fastboot. If it does not auto-enter, do so manually. Then manually check Fastboot connection. Regardless of whether a connection is found, do not close the script; follow the prompts.
:UNLOCKBL-FLASHABL-4
ECHO.1.Check Fastboot connection   2.Still not found after multiple checks   3.What is Fastboot?
call input choice #[1][2][3]
if "%choice%"=="2" ECHOC {%c_e%}Unlocking failed. Please join the feedback group.{%c_i%}{\n}& goto UNLOCKBL-FLASHABL-1
if "%choice%"=="3" call open pic pic\fastboot.jpg & goto UNLOCKBL-FLASHABL-4
fastboot.exe devices -l 2>&1 | find "fastboot" 1>nul 2>nul || ECHOC {%c_e%}Device not connected. {%c_i%}Check Device Manager, try reconnecting and check if drivers are installed.{%c_i%}{\n}&& goto UNLOCKBL-FLASHABL-4
call chkdev fastboot
ECHO.Reading device info... & call info fastboot
if "%info__fastboot__unlocked%"=="yes" ECHOC {%c_s%}Your device is now unlocked. {%c_i%}{\n}& set unlockbl_chk=y& goto UNLOCKBL-FLASHABL-1
ECHO.Executing unlock command. If a prompt appears, press volume keys to select "UNLOCK THE BOOTLOADER", then press power to confirm. Device will reboot. Do not close the script.
fastboot.exe flashing unlock 1>>%logfile% 2>&1 || ECHOC {%c_e%}Unlock command failed. Please check the log.{%c_i%}{\n}
:UNLOCKBL-FLASHABL-2
ECHO.1.I confirmed the unlock   2.I did not see an unlock confirmation prompt   3.What is the unlock prompt?
call input choice [1][2][3]
if "%choice%"=="3" call open pic pic\unlockbl.jpg & goto UNLOCKBL-FLASHABL-2
if "%choice%"=="1" set unlockbl_autoerase=y
if "%choice%"=="2" ECHOC {%c_e%}Unlocking failed. Please join the feedback group later.{%c_i%}{\n}
goto UNLOCKBL-FLASHABL-1
:UNLOCKBL-FLASHABL-1
ECHOC {%c_w%}This toolbox is made by KooAnn@SomeStealer, completely free, do not resell{%c_i%}{\n}
ECHOC {%c_i%}Device is in an abnormal state. The script will help restore it. Do not close the script; follow the prompts or bear the consequences. {%c_h%}No need to wait for boot. Manually enter 9008 now (see "How to Enter Each Mode" document in the toolbox folder)...{%c_i%}{\n}& call chkdev qcedl rechk 1
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
if "%blplan_frp%"=="y" ECHO.Restoring frp... & call write qcedl frp res\%product%\bak\frp_%baktime%.img %chkdev__port__qcedl%
if not "%parlayout:~0,2%"=="ab" (
    ECHO.Restoring abl... & call write qcedl abl res\%product%\bak\abl_%baktime%.elf %chkdev__port__qcedl%)
if "%parlayout:~0,2%"=="ab" (
    ::ECHO.Restoring lun4 partition table... & call partable qcedl writegpt %chkdev__port__qcedl% auto 4 main res\%product%\bak\gpt_main4_%baktime%.bin
    ECHO.Restoring abl_%slot__cur%... & call write qcedl abl_%slot__cur% res\%product%\bak\abl_%slot__cur%_%baktime%.elf %chkdev__port__qcedl%
    ECHO.Activating %slot__cur% slot... & call slot qcedl set %slot__cur%)
if "%unlockbl_autoerase%"=="y" ECHO.Setting auto factory reset... & call write qcedl misc tool\Android\misc_wipedata.img %chkdev__port__qcedl%
ECHO.Rebooting... & call reboot qcedl system
goto UNLOCKBL-DONE
:UNLOCKBL-special__ailsa_ii
ECHO.Rebooting to 9008... & call reboot system qcedl rechk 1
goto UNLOCKBL-special__ailsa_ii-START
:UNLOCKBL-special__ailsa_ii-START
ECHO.Sending bootloader... & call write qcedlsendfh %chkdev__port__qcedl% %framework_workspace%\res\%product%\devprg
for /f %%a in ('gettime.exe ^| find "."') do set baktime=%%a
ECHO.Backing up aboot... & call read qcedl aboot res\%product%\bak\aboot_%baktime%.mbn notice %chkdev__port__qcedl%
ECHO.Backing up fbop...  & call read qcedl fbop  res\%product%\bak\fbop_%baktime%.img  notice %chkdev__port__qcedl%
::ECHO.Backing up frp...   & call read qcedl frp   res\%product%\bak\frp_%baktime%.img   notice %chkdev__port__qcedl%
::ECHO.Patching frp to enable OEM unlock... & call imgkit patchfrp res\%product%\bak\frp_%baktime%.img %tmpdir%\frp_oemunlockon.img oemunlockon noprompt
ECHO.Flashing unlock aboot... & call write qcedl aboot res\%product%\aboot_unlock.mbn %chkdev__port__qcedl%
ECHO.Flashing unlock fbop...  & call write qcedl fbop  res\%product%\fbop_unlock.img  %chkdev__port__qcedl%
::ECHO.Flashing unlock frp...   & call write qcedl frp   %tmpdir%\frp_oemunlockon.img        %chkdev__port__qcedl%
ECHO.Rebooting to system... & call reboot qcedl system
ECHO.Device will automatically reboot. If USB debugging is not enabled after boot, enable it. If it won't boot, join the feedback group.
call chkdev system rechk 1
ECHO.Rebooting to Fastboot... & call reboot system fastboot rechk 1
ECHO.Executing unlock command...
fastboot.exe oem unlock 1>%tmpdir%\output.txt 2>&1 || ECHOC {%c_e%}Unlock command failed. Please check the log.{%c_i%}{\n}
type %tmpdir%\output.txt>>%logfile%
find "Device already : unlocked!" "%tmpdir%\output.txt" 1>nul 2>nul && ECHOC {%c_s%}Your device is already unlocked.{%c_i%}{\n}&& set unlockbl_chk=y&& goto UNLOCKBL-DONE
ECHO.If a confirmation prompt appears, press volume keys to select "Yes", then press power to confirm. Device will reboot and factory reset.
ECHO.1.I confirmed the unlock   2.I did not see an unlock confirmation prompt
call input choice [1][2]
if "%choice%"=="2" ECHOC {%c_e%}Unlocking failed. Please join the feedback group later.{%c_i%}{\n}
goto UNLOCKBL-DONE
:UNLOCKBL-DIRECT
ECHO.Rebooting to fastboot... & call reboot system fastboot rechk 1
:UNLOCKBL-DIRECT-START
ECHO.Reading device info... & call info fastboot
if "%info__fastboot__unlocked%"=="yes" ECHOC {%c_s%}Your device is now unlocked. {%c_i%}{\n}& set unlockbl_chk=y& goto UNLOCKBL-DONE
ECHO.Executing unlock command. If a prompt appears, press volume keys to select "UNLOCK THE BOOTLOADER", then press power to confirm. If no prompt, unlocking has failed.
fastboot.exe flashing unlock 1>>%logfile% 2>&1 || ECHOC {%c_e%}Unlock command failed. Please check the log.{%c_i%}{\n}
ECHO.1.I confirmed the unlock   2.I did not see an unlock confirmation prompt
call input choice [1][2]
if "%choice%"=="2" ECHOC {%c_e%}Unlocking failed. Please join the feedback group.{%c_i%}{\n}
goto UNLOCKBL-DONE
:UNLOCKBL-DONE
if "%unlockbl_chk%"=="y" goto UNLOCKBL-DONE-1
ECHO.
::ECHO.1.[Recommended] Check if unlock was successful
ECHO.1.View BL-unlocked device characteristics
ECHO.2.Continue (if unsure of success, re-run the unlock BL function; flashing in locked state may brick device)
call input choice #[1][2]
ECHO.
::if "%choice%"=="1" goto UNLOCKBL-1
if "%choice%"=="1" call open pic pic\blunlockedfeatures.jpg & goto UNLOCKBL-DONE
:UNLOCKBL-DONE-1
ECHO. & ECHOC {%c_s%}All done. {%c_i%}Yellow text on boot after unlocking is normal. If device won't boot, enter Recovery and wipe all data for factory reset. First boot after factory reset may be slow. {%c_h%}Press any key to return...{%c_i%}{\n}& pause>nul & goto MENU


:SELDEV
type conf\dev.csv | find /v "[product]" | find "[" | find /N "]" 1>%tmpdir%\dev.txt
CLS
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.Select / Change Model
ECHO.
ECHO.=--------------------------------------------------------------------=
ECHO.
ECHO.
ECHO.If you have a ZTE/Nubia/RedMagic device not supported by this toolbox, join the feedback group to contact the author.
ECHO.
ECHO.
for /f "tokens=1,3,4 delims=[]," %%a in (%tmpdir%\dev.txt) do (ECHO.[%%a] %%c  %%b& ECHO.)
ECHO.
call input choice
if "%choice%"=="" goto SELDEV
find "[%choice%][" "%tmpdir%\dev.txt" 1>nul 2>nul || goto SELDEV
ECHO.Switching model. Please do not close the window...
for /f "tokens=2 delims=[]," %%a in ('type %tmpdir%\dev.txt ^| find "[%choice%]["') do set product=%%a
call ztetoolbox confdevpre
call framework conf user.bat product %product%
call conf\dev-%product%.bat
goto MENU


:THEME
CLS
ECHOC {%c_a%}=--------------------------------------------------------------------={%c_i%}{\n}
ECHO.
ECHO.Change Script Theme
ECHO.
ECHOC {%c_a%}=--------------------------------------------------------------------={%c_i%}{\n}
ECHO.
ECHO.
ECHO.Note: Do not change theme while the script is running. Changes take effect after reopening the script.
ECHO.
ECHO.
ECHO.1.Default
ECHO.2.Classic
ECHO.3.Ubuntu
ECHO.4.TikTok Hacker
ECHO.5.Gold
ECHO.6.DOS
ECHO.7.Happy New Year
ECHO.
call input choice [1][2][3][4][5][6][7]
if "%choice%"=="1" set target=default
if "%choice%"=="2" set target=classic
if "%choice%"=="3" set target=ubuntu
if "%choice%"=="4" set target=douyinhacker
if "%choice%"=="5" set target=gold
if "%choice%"=="6" set target=dos
if "%choice%"=="7" set target=ChineseNewYear
::Load preview
call framework theme %target%
echo.@ECHO OFF>%tmpdir%\theme.bat
echo.mode con cols=50 lines=17 >>%tmpdir%\theme.bat
echo.cd ..>>%tmpdir%\theme.bat
echo.set path=%framework_workspace%;%framework_workspace%\tool\Win;%framework_workspace%\tool\Android;%path% >>%tmpdir%\theme.bat
echo.COLOR %c_i% >>%tmpdir%\theme.bat
echo.TITLE Theme Preview: %target% >>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_i%}Normal info{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_w%}Warning info{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_e%}Error info{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_s%}Success info{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_h%}Manual operation prompt{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_a%}Accent color{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.ECHOC {%c_we%}Dimmed color{%c_i%}{\n}>>%tmpdir%\theme.bat
echo.ECHO. >>%tmpdir%\theme.bat
echo.pause^>nul>>%tmpdir%\theme.bat
echo.EXIT>>%tmpdir%\theme.bat
call framework theme
start %tmpdir%\theme.bat
::Preview loaded
ECHO.
ECHO.Preview loaded. Apply this theme?
ECHO.1.Apply   2.Do not apply
call input choice #[1][2]
if "%choice%"=="1" call framework conf user.bat framework_theme %target%& ECHOC {%c_i%}Theme changed. Reopen the script for changes to take effect. {%c_h%}Press any key to close the script...{%c_i%}{\n}& call log %logger% I Theme changed to %target%& pause>nul & EXIT
if "%choice%"=="2" goto THEME






:FATAL
ECHO. & if exist tool\Win\ECHOC.exe (tool\Win\ECHOC {%c_e%}Sorry, the script encountered a problem and cannot continue. Please check the log. {%c_h%}Press any key to exit...{%c_i%}{\n}& pause>nul & EXIT) else (ECHO.Sorry, the script encountered a problem and cannot continue. Press any key to exit...& pause>nul & EXIT)
