@echo off
setlocal

:: Set directories
set "SCRIPT_DIR=%~dp0"
set "BINARIES_DIR=%SCRIPT_DIR%binaries"
set "TEXDIAG_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texdiag.exe"
set "TEXCONV_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texconv.exe"

:: Check PowerShell
powershell -Command "if ($PSVersionTable.PSVersion.Major -lt 3) { exit 1 }" 
if %errorlevel% neq 0 (
    echo PowerShell required
    exit /b 1
)

:: Create binaries dir
echo Creating binaries...
if not exist "%BINARIES_DIR%" mkdir "%BINARIES_DIR%"

:: Download texdiag.exe
echo Downloading texdiag...
powershell -Command "Invoke-WebRequest -Uri '%TEXDIAG_URL%' -OutFile '%BINARIES_DIR%\texdiag.exe'"
if %errorlevel% neq 0 (
    echo texdiag failed
    exit /b 1
)

:: Download texconv.exe
echo Downloading texconv...
powershell -Command "Invoke-WebRequest -Uri '%TEXCONV_URL%' -OutFile '%BINARIES_DIR%\texconv.exe'"
if %errorlevel% neq 0 (
    echo texconv failed
    exit /b 1
)

echo Downloads complete
endlocal
