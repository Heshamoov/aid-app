@echo off
REM Aid Platform Database Backup Script for Windows
REM Creates timestamped backups of the PocketBase database

echo =========================================
echo Aid Platform Database Backup
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

REM Run the backup script using Git Bash
echo Creating database backup...
echo.

bash "%~dp0backup-database.sh"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo =========================================
    echo SUCCESS: Backup completed!
    echo =========================================
    echo.
    echo Backups are stored in:
    echo - Local: %~dp0pb_data\backups\
    echo - Export: %~dp0..\exports\
    echo.
    echo You can copy export backups to external storage
    echo for additional safety.
    echo.
) else (
    echo.
    echo ERROR: Backup failed!
    echo Check the log file: %~dp0pb_data\backup.log
    echo.
)

pause

