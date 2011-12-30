; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "USBprog Flash Tool"
!define PRODUCT_VERSION "V0.2"
!define PRODUCT_PUBLISHER "Benedikt Sauter, Robert Schilling"
!define PRODUCT_WEB_SITE "http://www.embedded-projects.net/usbprog"
!define PRODUCT_EXE_FILE "usbprog-gui.exe"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_EXE_FILE}"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"
!define SHORTCUT_NAME "${PRODUCT_NAME}"



; MUI 1.67 compatible ------
!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"

; Language Selection Dialog Settings
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!define MUI_LICENSEPAGE_RADIOBUTTONS
!insertmacro MUI_PAGE_LICENSE "..\COPYING"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${SHORTCUT_NAME}"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES

Page Custom libusb             ;Install Libusb
; Finish page
!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_EXE_FILE}"
;Page Custom delFilter
!insertmacro MUI_PAGE_FINISH



; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "German"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "Installer.exe"
InstallDir "$PROGRAMFILES\${SHORTCUT_NAME}"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Function .onInit
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Section "!Usbprog Gui" SEC01
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "${PRODUCT_EXE_FILE}"
  SetOutPath "$WINDIR\inf\"
  SetOverwrite off
  File "usbprog.inf"
  File "openOCD.inf"
  File "usbprog.cat"
  File "openOCD.cat"
  File "usbprog_x64.cat"
  File "openOCD_x64.cat"
  SetOutPath "$WINDIR\system32\"
  File "libusb0.dll"
  SetOutPath "$WINDIR\system32\drivers\"
  File "libusb0.sys"

; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\${SHORTCUT_NAME}.lnk" "$INSTDIR\${PRODUCT_EXE_FILE}"
  CreateShortCut "$DESKTOP\${SHORTCUT_NAME}.lnk" "$INSTDIR\${PRODUCT_EXE_FILE}"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "LibUSB" SEC02
  SetOutPath "$INSTDIR"
  File "libusb-win32-filter-bin-0.1.12.1.exe"
  ; Shortcuts
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Emmbedded Projects.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_EXE_FILE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_EXE_FILE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} "Usbprog Gui Application"
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC02} "LibUsb for USB Support"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function libusb
 IfFileExists "$INSTDIR\libusb-win32-filter-bin-0.1.12.1.exe" 0 NO_LIB
      Exec "$INSTDIR\libusb-win32-filter-bin-0.1.12.1.exe"
   NO_LIB:
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) wurde erfolgreich deinstalliert."
FunctionEnd

Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "M�chten Sie $(^Name) und alle seinen Komponenten deinstallieren?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\libusb-win32-filter-bin-0.1.12.1.exe"
 ; Delete "$WINDIR\system32\drivers\libusb0.sys"
 ; Delete "$WINDIR\system32\libusb0.dll"
 ; Delete "$WINDIR\inf\usbprog_x64.cat"
 ; Delete "$WINDIR\inf\usbprog_openocd.cat"
 ; Delete "$WINDIR\inf\usbprog.cat"
 ; Delete "$WINDIR\inf\usbprog_openocd.inf"
 ; Delete "$WINDIR\inf\usbprog.inf"
  Delete "$INSTDIR\${PRODUCT_EXE_FILE}"

  Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\Website.lnk"
  Delete "$DESKTOP\${SHORTCUT_NAME}.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\${SHORTCUT_NAME}.lnk"

  RMDir "$WINDIR\system32\drivers\"
  RMDir "$WINDIR\system32\"
  RMDir "$WINDIR\inf\"
  RMDir "$SMPROGRAMS\$ICONS_GROUP"
  RMDir "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd