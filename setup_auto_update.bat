@echo off
REM Setup Auto-Update Scheduled Task for Windows
REM This creates a Windows Task Scheduler task to check for updates daily

echo =========================================
echo Aid Platform Auto-Update Setup
echo =========================================
echo.
echo This will create a scheduled task to automatically
echo check for updates once per day at 3:00 AM.
echo.
echo The task will:
echo - Check for updates from GitHub
echo - Download and install updates if available
echo - Restart the application automatically
echo - Create backups before updating
echo - Log all activities
echo.

set /p CONFIRM="Do you want to continue? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Setup cancelled.
    pause
    exit /b 0
)

echo.
echo Creating scheduled task...

REM Create the scheduled task
schtasks /create /tn "Aid Platform Auto-Update" /tr "\"%~dp0update_app.bat\"" /sc daily /st 03:00 /f /rl highest

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =========================================
    echo SUCCESS: Auto-update task created!
    echo =========================================
    echo.
    echo The application will now automatically check for
    echo updates every day at 3:00 AM.
    echo.
    echo You can:
    echo - View the task in Windows Task Scheduler
    echo - Run updates manually using update_app.bat
    echo - Check update logs in: %~dp0logs\update.log
    echo.
    echo To disable auto-updates, run:
    echo   schtasks /delete /tn "Aid Platform Auto-Update"
    echo.
) else (
    echo.
    echo ERROR: Failed to create scheduled task!
    echo Please run this script as Administrator.
    echo.
)

pause

