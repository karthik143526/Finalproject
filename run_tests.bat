@echo off
REM ========================================
REM EcoWaste - Comprehensive E2E Test Suite
REM ========================================

echo.
echo ================================================================================
echo ECOWASTE COMPREHENSIVE E2E TEST EXECUTION
echo ================================================================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in PATH
    echo Please install Python 3.8+ and add it to your PATH
    pause
    exit /b 1
)

echo [1/4] Checking Python version...
python --version

echo.
echo [2/4] Installing dependencies...
pip install -r requirements.txt --quiet
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)

echo.
echo [3/4] Verifying Selenium WebDriver...
python -c "from selenium import webdriver; print('[OK] Selenium is ready')"
if %errorlevel% neq 0 (
    echo [ERROR] Selenium verification failed
    pause
    exit /b 1
)

echo.
echo [4/4] Running comprehensive E2E tests...
echo ================================================================================
echo.

python comprehensive_e2e_tests.py

echo.
echo ================================================================================
echo TEST EXECUTION COMPLETED
echo ================================================================================
echo.
echo Check the generated Excel report for detailed results.
echo.

pause
