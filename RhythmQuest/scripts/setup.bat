@echo off
REM RhythmQuest Setup Script for Windows
REM This script automates the setup process

echo.
echo ==========================================
echo   RhythmQuest Setup Script
echo ==========================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python from https://www.python.org
    pause
    exit /b 1
)

echo [1/5] Checking Python installation...
python --version
echo.

REM Install required packages
echo [2/5] Installing Python packages...
echo This may take a few minutes...
pip install -r requirements.txt
if errorlevel 1 (
    echo ERROR: Failed to install packages
    pause
    exit /b 1
)
echo.

REM Check if .env exists
if not exist ".env" (
    echo [3/5] Creating .env file...
    (
        echo # Database Configuration
        echo MYSQL_HOST=localhost
        echo MYSQL_USER=root
        echo MYSQL_PASSWORD=root
        echo MYSQL_DB=rhythmquest
        echo.
        echo # Flask Configuration
        echo FLASK_SECRET_KEY=your_super_secret_key_here_change_this_in_production
        echo FLASK_ENV=development
    ) > .env
    echo .env file created! Please update it with your database credentials.
) else (
    echo [3/5] .env file already exists. Skipping creation.
)
echo.

REM Create logs directory
echo [4/5] Setting up logs directory...
if not exist "logs" mkdir logs
echo.

REM Display next steps
echo [5/5] Setup complete!
echo.
echo ==========================================
echo   NEXT STEPS
echo ==========================================
echo.
echo 1. Update your .env file with correct MySQL credentials:
echo    - MYSQL_USER (default: root)
echo    - MYSQL_PASSWORD (your MySQL password)
echo.
echo 2. Set up the database by running in MySQL:
echo    - Open MySQL Workbench or Command Line
echo    - Run: SOURCE database_setup.sql;
echo.
echo 3. Start the Flask application:
echo    python app.py
echo.
echo 4. Open your browser and go to:
echo    http://localhost:5000
echo.
echo 5. Read TESTING.md for how to test all features
echo.
echo ==========================================
echo.

pause
