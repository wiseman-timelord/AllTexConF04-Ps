@echo off
setlocal

set BINARIES_DIR=.\binaries
set TEXDIAG_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texdiag.exe
set TEXCONV_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texconv.exe

echo Creating binaries directory...
if not exist "%BINARIES_DIR%" mkdir "%BINARIES_DIR%"

echo Downloading texdiag.exe...
powershell -Command "Invoke-WebRequest -Uri '%TEXDIAG_URL%' -OutFile '%BINARIES_DIR%\texdiag.exe'"

echo Downloading texconv.exe...
powershell -Command "Invoke-WebRequest -Uri '%TEXCONV_URL%' -OutFile '%BINARIES_DIR%\texconv.exe'"

echo Installation complete.
endlocal
