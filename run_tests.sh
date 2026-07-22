#!/bin/bash
# ========================================
# EcoWaste - Comprehensive E2E Test Suite
# ========================================

echo ""
echo "================================================================================"
echo "ECOWASTE COMPREHENSIVE E2E TEST EXECUTION"
echo "================================================================================"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "[ERROR] Python3 is not installed or not in PATH"
    echo "Please install Python 3.8+ and add it to your PATH"
    exit 1
fi

echo "[1/4] Checking Python version..."
python3 --version

echo ""
echo "[2/4] Installing dependencies..."
pip3 install -r requirements.txt --quiet
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to install dependencies"
    exit 1
fi

echo ""
echo "[3/4] Verifying Selenium WebDriver..."
python3 -c "from selenium import webdriver; print('[OK] Selenium is ready')"
if [ $? -ne 0 ]; then
    echo "[ERROR] Selenium verification failed"
    exit 1
fi

echo ""
echo "[4/4] Running comprehensive E2E tests..."
echo "================================================================================"
echo ""

python3 comprehensive_e2e_tests.py

echo ""
echo "================================================================================"
echo "TEST EXECUTION COMPLETED"
echo "================================================================================"
echo ""
echo "Check the generated Excel report for detailed results."
echo ""
