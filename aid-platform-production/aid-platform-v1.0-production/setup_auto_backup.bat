@echo off
REM Setup Automatic Database Backup Scheduled Tasks for Windows
REM Creates hourly and daily backup tasks

echo =========================================
echo Aid Platform Auto-Backup Setup
echo =========================================
echo.
echo This will create scheduled tasks to automatically
echo backup the database:
echo.
echo 1. HOURLY: Every hour (keeps last 24 backups)
echo 2. DAILY: Every day at 2:00 AM (keeps last 30 backups)
echo.
echo This protects your data against:
echo - Power outages
echo - Hardware failures
echo - Accidental data loss
echo.

set /p CONFIRM="Do you want to continue? (Y/N): "
if /i not "%CONFIRM%"=="Y" (
    echo Setup cancelled.
    pause
    exit /b 0
)

echo.
echo Creating scheduled tasks...
echo.

REM Create hourly backup task
echo [1/2] Creating hourly backup task...
schtasks /create /tn "Aid Platform Hourly Backup" /tr "\"%~dp0backend\backup_database.bat\"" /sc hourly /f /rl highest

if %ERRORLEVEL% EQU 0 (
    echo     SUCCESS: Hourly backup task created
) else (
    echo     ERROR: Failed to create hourly backup task
    echo     Please run this script as Administrator
    pause
    exit /b 1
)

REM Create daily backup task
echo [2/2] Creating daily backup task...
schtasks /create /tn "Aid Platform Daily Backup" /tr "\"%~dp0backend\backup_database.bat\"" /sc daily /st 02:00 /f /rl highest

if %ERRORLEVEL% EQU 0 (
    echo     SUCCESS: Daily backup task created
) else (
    echo     ERROR: Failed to create daily backup task
    echo     Please run this script as Administrator
    pause
    exit /b 1
)

echo.
echo =========================================
echo SUCCESS: Auto-backup tasks created!
echo =========================================
echo.
echo Your database will now be automatically backed up:
echo - Every hour (local backups)
echo - Every day at 2:00 AM (export backups)
echo.
echo Backup locations:
echo - Local:  %~dp0backend\pb_data\backups\
echo - Export: %~dp0exports\
echo.
echo You can:
echo - View tasks in Windows Task Scheduler
echo - Run manual backup using: backend\backup_database.bat
echo - Check backup logs in: backend\pb_data\backup.log
echo.
echo IMPORTANT: Regularly copy export backups to external
echo storage (USB drive, cloud storage) for additional safety!
echo.
echo To disable auto-backups, run:
echo   schtasks /delete /tn "Aid Platform Hourly Backup"
echo   schtasks /delete /tn "Aid Platform Daily Backup"
echo.

pause

