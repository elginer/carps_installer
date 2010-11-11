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

; Location of ruby.exe
Var ruby
; Location of gem.exe
Var gem

; Detect if ruby is successfully installed.
Section TestRuby
   SearchPath $ruby "ruby.exe"
   SearchPath $gem "gem.bat"
   IfErrors ruby_bad ruby_good
   ruby_bad:
      MessageBox MB_OK "Installing Ruby failed.$\nDid you forget to 'Add Ruby executables to your PATH'?$\nUninstall Ruby, if possible, and then try to run this installer again.$\nRemember to select that option the next time.$\nPress OK to quit."
      QUIT
   ruby_good:
SectionEnd

; Install a gem that's included with the installer
; Write the name of the gem to $current_gem first
; Also, you must set File
; And the output folder
Var current_gem
Function InstallDistributedGem
   ExecWait "$gem install -l '$instdir\$current_gem'"
FunctionEnd

; Install a gem from the internet
; Write the name of the gem to $current_gem first
Function InstallGem
   ExecWait "$gem install $current_gem"
FunctionEnd

; Install win32 console
Section InstallWin32Console
   StrCpy $current_gem "win32console"
   call InstallGem
SectionEnd

; Now install CARPS
Section InstallCARPS
   StrCpy $current_gem "carps-0.3.0.gem"
   SetOutpath "$instdir"
   File "carps-0.3.0.gem"
   call InstallDistributedGem
   CreateShortCut "$DESKTOP\Play CARPS.lnk" "$instdir\$current_gem" "-p"
   CreateShortCut "$DESKTOP\Host CARPS.lnk" "$instdir\$current_gem" "-m"
SectionEnd

; Now install Fools
Section InstallFools
   StrCpy $current_gem "fools-0.0.5.gem"
   SetOutpath "$instdir"
   File "fools-0.0.5.gem"
   call InstallDistributedGem
SectionEnd
