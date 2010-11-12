; Installer for CARPS
outFile "install_carps.exe"

name "CARPS"

; The default install location
InstallDir $PROGRAMFILES\CARPS

; A page asking where CARPS should be installed
DirText "Where should CARPS be installed?"

; Install ruby
Section -Prerequisites
   SetOutPath $INSTDIR\Prerequisites
   MessageBox MB_YESNO "Install Ruby 1.9? (Required to run CARPS)." /SD IDYES IDNO endRuby
      File "rubyinstaller-1.9.2-p0.exe"
      MessageBox MB_OK "IMPORTANT: When the following installer runs, you MUST choose to 'Add Ruby executables to your PATH'"
      ExecWait "$INSTDIR\Prerequisites\rubyinstaller-1.9.2-p0.exe"
      Goto endRuby
   endRuby:
SectionEnd

; Detect if ruby is successfully installed.
Section TestRuby
   ExecWait "ruby -e 'exit 0'"
   ExecWait "gem.bat -h"
   IfErrors ruby_bad ruby_good
   ruby_bad:
      Abort "Install failed: could not find ruby in PATH."
   ruby_good:
SectionEnd

; Install a gem that's included with the installer
; Write the name of the gem to $current_gem first
; Also, you must set File
; And the output folder
Var current_gem
Function InstallDistributedGem
   ExecWait "gem.bat install -l '$INSTDIR\$current_gem'"
FunctionEnd

; Install win32 console
Section InstallWin32Console
   StrCpy $current_gem "win32console-1.3.0-x86-mingw32.gem"
   SetOutpath "$INSTDIR"
   File "win32console-1.3.0-x86-mingw32.gem"
   call InstallDistributedGem
SectionEnd

; Install Highline
Section InstallHighline
   StrCpy $current_gem "highline-1.6.1.gem"
   SetOutpath "$INSTDIR"
   File "highline-1.6.1.gem"
   call InstallDistributedGem
SectionEnd

; Now install CARPS
Section InstallCARPS
   StrCpy $current_gem "carps-0.3.1.gem"
   SetOutpath "$INSTDIR"
   File "carps-0.3.1.gem"
   call InstallDistributedGem
   File "setup_carps.bat"
   ExecWait "$INSTDIR\setup_carps.bat"
   CreateShortCut "$DESKTOP\Play CARPS.lnk" "carps" "-p"
   CreateShortCut "$DESKTOP\Host CARPS.lnk" "carps" "-m"
SectionEnd

; Now install Fools
Section InstallFools
   StrCpy $current_gem "fools-0.0.5.gem"
   SetOutpath "$INSTDIR"
   File "fools-0.0.5.gem"
   call InstallDistributedGem
   File "setup_fools.bat"
   ExecWait "$INSTDIR\setup_fools.bat"
SectionEnd
