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

:: Set directories
set "SCRIPT_DIR=%~dp0"
set "BINARIES_DIR=%SCRIPT_DIR%binaries"
set "CACHE_DIR=%SCRIPT_DIR%cache"
set "TEXDIAG_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texdiag.exe"
set "TEXCONV_URL=https://github.com/microsoft/DirectXTex/releases/download/dec2023/texconv.exe"
set "GIT_7ZA_URL=https://github.com/aaubertsolutions/7za.git"

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

:: Clone 7za
echo Downloading 7za...
pushd "%CACHE_DIR%"
git clone "%GIT_7ZA_URL%" 7za
if %errorlevel% neq 0 (
    echo 7za clone failed
    popd
    pause
    exit /b 1
)
popd
echo ...7za Package Downloaded.
echo.
timeout /t 1 >nul

:: Copy 7za files
echo Copying 7za files...
copy "%CACHE_DIR%\7za\7za.exe" "%BINARIES_DIR%\7za.exe"
copy "%CACHE_DIR%\7za\7za.dll" "%BINARIES_DIR%\7za.dll"
copy "%CACHE_DIR%\7za\7zxa.dll" "%BINARIES_DIR%\7zxa.dll"
echo ...7za Installed.
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
