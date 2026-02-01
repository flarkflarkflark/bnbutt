!include "MUI2.nsh"

Name "bnbutt"
OutFile "dist\\bnbutt-setup.exe"
InstallDir "$PROGRAMFILES64\\bnbutt"
RequestExecutionLevel user

!define MUI_ABORTWARNING

!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

Section "Install"
  SetOutPath "$INSTDIR"
  File /oname=bnbutt.exe "dist\\bnbutt.exe"
  File /oname=bnbutt.ico "assets\\icons\\bnbutt.ico"

  CreateDirectory "$SMPROGRAMS\\bnbutt"
  CreateShortCut "$SMPROGRAMS\\bnbutt\\bnbutt.lnk" "$INSTDIR\\bnbutt.exe" "" "$INSTDIR\\bnbutt.ico"
SectionEnd

Section "Uninstall"
  Delete "$SMPROGRAMS\\bnbutt\\bnbutt.lnk"
  RMDir "$SMPROGRAMS\\bnbutt"
  Delete "$INSTDIR\\bnbutt.exe"
  Delete "$INSTDIR\\bnbutt.ico"
  RMDir "$INSTDIR"
SectionEnd
