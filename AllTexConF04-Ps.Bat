REM Script: AllTexConF04-Ps.Bat
@echo off

:: Initialization
mode con cols=64 lines=30
color 0E
title AllTexConF04-Ps
cd /d "%~dp0"
echo.
echo Launcher Script Started...
echo.
timeout /t 2 /nobreak >nul

:: Main Menu
:menu
cls
echo      ^_    ^_ ^_ ^_^_^_^_^_          ^_^_^_^_            ^_^_^_^_^_ ^_^_^_  ^_  ^_
echo     / \  ^| ^| ^|^_   ^_^|^_^_^_^_  ^_^_/ ^_^_^_^|^_^_^_  ^_ ^_^_ ^|  ^_^_^_/ ^_ \^| ^|^| ^|
echo    / ^_ \ ^| ^| ^| ^| ^|/ ^_ \ \/ / ^|   / ^_ \^| '^_ \^| ^|^_ ^| ^| ^| ^| ^|^| ^|^_
echo   / ^_^_^_ \^| ^| ^| ^| ^|  ^_^_/^>  ^<^| ^|^_^_^| (^_) ^| ^| ^| ^|  ^_^|^| ^|^_^| ^|^_^_   ^_^|
echo  /^_/   \^_\^_^|^_^| ^|^_^|\^_^_^_/^_/\^_\\^_^_^_^_\^_^_^_/^|^_^| ^|^_^|^_^|   \^_^_^_/   ^|^_^|
echo ======================( AllTexConF04-Ps )======================
echo.
echo                     1. Run AllTexConF04-Ps,
echo                     2. Check File Integrity,
echo.

:: Variables
set /p choice=Select, Options=1-2, Exit=X: 
echo.
if "%choice%"=="1" goto executeMain
if "%choice%"=="2" goto checkScript
if "%choice%"=="x" goto end
echo.
echo Invalid choice. Try again.
pause
goto menu

:: Check for presence of pwsh.exe and execute main.ps1
:executeMain
where pwsh >nul 2>&1
if %ERRORLEVEL% equ 0 (
    echo Launching as PowerShellCore Script...
    echo.
    timeout /t 2 /nobreak >nul
    pwsh.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1" >".\Errors-Crash.Log" 2>&1
    echo ...Main Script Exited.
) else (
    echo Launching as PowerShell Script...
    echo.
    timeout /t 2 /nobreak >nul
    powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\main.ps1" >".\Errors-Crash.Log" 2>&1
    echo ...Main Script Exited.
)
timeout /t 1 /nobreak >nul
goto menu


:: Function to Check File Structure
:checkScript
echo Checking Script Files...
set missing=0
timeout /t 1 /nobreak >nul

:: Check for PowerShell script files
if not exist ".\scripts\processing.ps1" set missing=1
if not exist ".\scripts\configuration.psd1" set missing=1
if not exist ".\main.ps1" set missing=1

if %missing%==1 (
    echo ...Failure, Re-Install Program!
) else (
    echo ...Program Files Correct.
)
echo.
timeout /t 2 /nobreak >nul
goto menu

:: End Function
:end
echo.
echo ...Launcher Script Finished.
echo.
pause
