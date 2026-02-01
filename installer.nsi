; bnbutt NSIS installer script
; Requires: NSIS 3.x

!include "MUI2.nsh"

; ---------------------------------------------------------------------------
;  Build-time defines (passed via makensis -D)
;    VERSION   – e.g. "0.1.14"
;    PKG_DIR   – directory containing butt.exe + DLLs
; ---------------------------------------------------------------------------

!ifndef VERSION
  !define VERSION "0.0.0"
!endif

!ifndef PKG_DIR
  !define PKG_DIR "pkg"
!endif

Name "bnbutt ${VERSION}"
OutFile "bnbutt-${VERSION}-windows-x64-setup.exe"
InstallDir "$PROGRAMFILES64\bnbutt"
InstallDirRegKey HKLM "Software\bnbutt" "InstallDir"
RequestExecutionLevel admin

; ---------------------------------------------------------------------------
;  UI settings
; ---------------------------------------------------------------------------
!define MUI_ICON "icons\butt.ico"
!define MUI_UNICON "icons\butt.ico"
!define MUI_ABORTWARNING

; ---------------------------------------------------------------------------
;  Pages
; ---------------------------------------------------------------------------
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_LANGUAGE "English"

; ---------------------------------------------------------------------------
;  Installer section
; ---------------------------------------------------------------------------
Section "Install"
  SetOutPath "$INSTDIR"

  ; Copy all files from the packaging directory (exe + DLLs)
  File /r "${PKG_DIR}\*.*"

  ; Write uninstaller
  WriteUninstaller "$INSTDIR\uninstall.exe"

  ; Registry keys for Add/Remove Programs
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt" \
    "DisplayName" "bnbutt - broadcast using this tool"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt" \
    "UninstallString" '"$INSTDIR\uninstall.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt" \
    "DisplayIcon" '"$INSTDIR\butt.exe"'
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt" \
    "DisplayVersion" "${VERSION}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt" \
    "Publisher" "bnbutt"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt" \
    "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt" \
    "NoRepair" 1

  WriteRegStr HKLM "Software\bnbutt" "InstallDir" "$INSTDIR"

  ; Start menu shortcut
  CreateDirectory "$SMPROGRAMS\bnbutt"
  CreateShortCut "$SMPROGRAMS\bnbutt\bnbutt.lnk" "$INSTDIR\butt.exe"
  CreateShortCut "$SMPROGRAMS\bnbutt\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

; ---------------------------------------------------------------------------
;  Uninstaller section
; ---------------------------------------------------------------------------
Section "Uninstall"
  ; Remove files and directory
  RMDir /r "$INSTDIR"

  ; Remove start menu shortcuts
  RMDir /r "$SMPROGRAMS\bnbutt"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\bnbutt"
  DeleteRegKey HKLM "Software\bnbutt"
SectionEnd
