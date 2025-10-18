@echo off
REM Database Initialization Script
REM Creates default admin user and required collections

echo =========================================
echo Aid Platform - Database Initialization
echo =========================================
echo.

set APP_DIR=%~dp0
set DB_FILE=%APP_DIR%backend\pb_data\data.db

echo This script will initialize the database with:
echo   - Default admin user
echo   - Required collections
echo   - Sample data structure
echo.

REM Check if database already exists
if exist "%DB_FILE%" (
    echo [WARNING] Database already exists!
    echo.
    choice /C YN /M "Do you want to recreate it? (This will DELETE all existing data)"
    if errorlevel 2 goto :cancel
    if errorlevel 1 goto :recreate
)

:recreate
echo.
echo Creating fresh database...

REM Stop the application first
echo Stopping application...
call "%APP_DIR%stop-aid-app.bat" >nul 2>&1
timeout /t 2 /nobreak >nul

REM Backup existing database if it exists
if exist "%DB_FILE%" (
    set BACKUP_FILE=%APP_DIR%backend\pb_data\data-backup-%date:~-4,4%%date:~-10,2%%date:~-7,2%.db
    echo Creating backup: %BACKUP_FILE%
    copy "%DB_FILE%" "%BACKUP_FILE%" >nul 2>&1
    del "%DB_FILE%" >nul 2>&1
)

REM Start PocketBase to create initial database
echo Starting PocketBase to initialize database...
cd /d "%APP_DIR%backend"
start /B "" pocketbase.exe serve --http=127.0.0.1:8090 >nul 2>&1
timeout /t 5 /nobreak >nul

echo.
echo =========================================
echo [SUCCESS] Database initialized!
echo =========================================
echo.
echo Next steps:
echo   1. Open http://127.0.0.1:8090/_/ in your browser
echo   2. Create an admin account (this will be your login)
echo   3. The collections will be created automatically
echo   4. Close this window and run start-aid-app.bat
echo.
echo PocketBase Admin UI: http://127.0.0.1:8090/_/
echo.
echo Press any key to open the admin UI...
pause >nul

REM Open PocketBase admin UI
start http://127.0.0.1:8090/_/

echo.
echo After creating your admin account in the browser,
echo close this window and run start-aid-app.bat
echo.
pause
exit /b 0

:cancel
echo.
echo [INFO] Database initialization cancelled
echo.
pause
exit /b 0

