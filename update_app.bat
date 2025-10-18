@echo off
REM Aid Platform Manual Update Script for Windows
REM This script checks for and applies updates from GitHub

echo =========================================
echo Aid Platform Update Tool
echo =========================================
echo.

REM Check if Git Bash is available
where bash >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Git Bash not found!
    echo Please install Git for Windows from: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

REM Run the update script using Git Bash
echo Checking for updates...
echo.

bash "%~dp0update-aid-app.sh" --force

echo.
echo Update check complete!
echo.
pause

