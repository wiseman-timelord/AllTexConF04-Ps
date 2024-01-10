REM Script: Setup-Install.Bat
@echo off

:: Initialization
mode con cols=60 lines=30
color 0E
title AllTexConFO4 Installer
cd /d "%~dp0"
echo.
echo Installer Script Started...
echo.
timeout /t 2 /nobreak >nul
setlocal

:: Set Locations
set "SCRIPT_DIR=%~dp0"
set "BINARIES_DIR=%SCRIPT_DIR%binaries"
set "CACHE_DIR=%SCRIPT_DIR%cache"
set "TEXDIAG_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texdiag.exe"
set "TEXCONV_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texconv.exe"
set "SevenZipR_URL=https://www.7-zip.org/a/7zr.exe"
set "BSARCH_URL=https://github.com/TES5Edit/TES5Edit/releases/download/xedit-4.1.5/xEdit.4.1.5.EXPERIMENTAL.7z"

:: Create directories
echo Creating directories...
if not exist "%BINARIES_DIR%" mkdir "%BINARIES_DIR%"
if not exist "%CACHE_DIR%" mkdir "%CACHE_DIR%"
echo ...Directories Created.
echo.
timeout /t 1 >nul

:: Download DirectXTex files
echo Downloading DirectXTex Files...
powershell -Command "Invoke-WebRequest -Uri '%TEXDIAG_URL%' -OutFile '%CACHE_DIR%\texdiag.exe'"
powershell -Command "Invoke-WebRequest -Uri '%TEXCONV_URL%' -OutFile '%CACHE_DIR%\texconv.exe'"
echo ...DirectXTex Files Downloaded.
echo.
timeout /t 1 >nul

:: Move DirectXTex files to Binaries
echo Installing DirectXTex Files...
move /Y "%CACHE_DIR%\texdiag.exe" "%BINARIES_DIR%"
move /Y "%CACHE_DIR%\texconv.exe" "%BINARIES_DIR%"
echo ...DirectXTex Installed.
echo.
timeout /t 1 >nul

:: Download 7zr
echo Downloading 7zr...
powershell -Command "Invoke-WebRequest -Uri '%SevenZipR_URL%' -OutFile '%CACHE_DIR%\7zr.exe'"
echo ...7zr Downloaded.
echo.
timeout /t 1 >nul

:: Download BSArch
echo Downloading BSArch...
powershell -Command "Invoke-WebRequest -Uri '%BSARCH_URL%' -OutFile '%CACHE_DIR%\xEdit.4.1.5.EXPERIMENTAL.7z'"
echo ...BSArch Downloaded.
echo.
timeout /t 1 >nul

:: Unpack BSArch
echo Unpacking BSArch...
"%CACHE_DIR%\7zr.exe" x "%CACHE_DIR%\xEdit.4.1.5.EXPERIMENTAL.7z" -o"%CACHE_DIR%" BSArch64.exe
echo ...BSArch Unpacked.
echo.
timeout /t 1 >nul

:: Copy BSArch files
echo Copying BSArch files...
move /Y "%CACHE_DIR%\BSArch64.exe" "%BINARIES_DIR%\BSArch64.exe"
echo ...BSArch Installed.
echo.
timeout /t 1 >nul

:: Clear cache contents
echo Cleaning Up...
del /q "%CACHE_DIR%\*.*"
for /d %%x in ("%CACHE_DIR%\*") do rd /s /q "%%x"
echo ...Cleanup Complete.
echo.
timeout /t 1 >nul

:: End Of File
echo.
echo.
echo ...Installer Script Completed.
echo.
timeout /t 3 >nul
endlocal
exit /b 0
