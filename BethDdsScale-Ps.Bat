REM Script: BethDdsScale-Ps.Bat
@echo off

:: Initialization
mode con cols=64 lines=30
color 80
title BethDdsScale-Ps
cd /d "%~dp0"
echo.
echo Launcher Script Started...
echo.
timeout /t 2 /nobreak >nul
echo Cleaning up..
if exist ".\Errors-Crash.Log" (
    echo ...Deleting Log...
    del ".\Errors-Crash.Log"
)
echo ..Cleaning Done.
echo.
timeout /t 1 /nobreak >nul

:: Main Menu
:menu
cls
echo    ^_^_^_^_       ^_   ^_     ^_^_^_^_      ^_     ^_^_^_^_            ^_      
echo   ^| ^_^_ )  ^_^_^_^| ^|^_^| ^|^_^_ ^|  ^_ \  ^_^_^| ^|^_^_^_/ ^_^_^_^|  ^_^_^_ ^_^_ ^_^| ^| ^_^_^_ 
echo   ^|  ^_ \ / ^_ \ ^_^_^| '^_ \^| ^| ^| ^|/ ^_` / ^_^_\^_^_^_ \ / ^_^_/ ^_` ^| ^|/ ^_ \
echo   ^| ^|^_) ^|  ^_^_/ ^|^_^| ^| ^| ^| ^|^_^| ^| (^_^| \^_^_ \^_^_^_) ^| (^_^| (^_^| ^| ^|  ^_^_/
echo   ^|^_^_^_^_/ \^_^_^_^|\^_^_^|^_^| ^|^_^|^_^_^_^_/ \^_^_,^_^|^_^_^_/^_^_^_^_/ \^_^_^_\^_^_,^_^|^_^|\^_^_^_^|
echo.
echo ======================( BethDdsScale-Ps )======================
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo                     1. Run BethDdsScale-Ps,
echo.
echo                     2. Check File Integrity,
echo.
echo                       X. Exit Launcher.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo ---------------------------------------------------------------

:: Variables
set /p choice=Select, Options=1-2, Exit=X: 
if "%choice%"=="1" goto executeMain
if "%choice%"=="2" goto checkScript
if "%choice%"=="x" goto end
echo Invalid choice. Try again.
pause
goto menu

:: Check for presence of pwsh.exe and execute main.ps1
:executeMain
where pwsh >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Launching as PowerShellCore Script..
    timeout /t 2 /nobreak >nul
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1" 2>".\Errors-Crash.Log"
    echo ..Main Script Exited.
) else (
    echo Launching as PowerShell Script..
    timeout /t 2 /nobreak >nul
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1" 2>".\Errors-Crash.Log"
    echo ..Main Script Exited.
)
timeout /t 1 /nobreak >nul
goto menu



:: Function to Check File Structure
:checkScript
cls
echo.
echo Checking Script Files..
set missing=0
timeout /t 1 /nobreak >nul

:: Check for PowerShell script files
if not exist ".\scripts\processing.ps1" set missing=1
if not exist ".\scripts\configuration.psd1" set missing=1
if not exist ".\main.ps1" set missing=1

if %missing%==1 (
    echo ..Failure, Re-Install Program!
) else (
    echo ..Program Files Correct.
)
echo.
timeout /t 1 /nobreak >nul
echo Returning to menu..
echo.
timeout /t 2 /nobreak >nul
goto menu

:: End Function
:end
echo ...Exit Process Initiated.
timeout /t 5 /nobreak >nul
