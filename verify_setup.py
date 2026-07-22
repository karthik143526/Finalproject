"""
Quick Setup Verification Script
Checks all prerequisites before running E2E tests
"""

import sys
import subprocess
import platform
import urllib.request
from pathlib import Path

def check_python_version():
    """Check Python version"""
    version = sys.version_info
    if version.major < 3 or (version.major == 3 and version.minor < 8):
        print("✗ Python 3.8+ required")
        return False
    print(f"✓ Python {version.major}.{version.minor}.{version.micro}")
    return True

def check_dependencies():
    """Check required Python packages"""
    required = ['selenium', 'openpyxl', 'webdriver_manager']
    missing = []
    
    for package in required:
        try:
            __import__(package)
            print(f"✓ {package} installed")
        except ImportError:
            print(f"✗ {package} NOT installed")
            missing.append(package)
    
    if missing:
        print(f"\nInstall missing packages:")
        print(f"pip install {' '.join(missing)}")
        return False
    return True

def check_server():
    """Check if server is running"""
    url = "http://localhost/finalproject"
    try:
        response = urllib.request.urlopen(url, timeout=3)
        print(f"✓ Server running at {url}")
        return True
    except:
        print(f"✗ Server NOT running at {url}")
        print("  Start XAMPP: Apache and MySQL services")
        return False

def check_browser():
    """Check if Chrome/Chromium is installed"""
    try:
        from webdriver_manager.chrome import ChromeDriverManager
        ChromeDriverManager().install()
        print("✓ Chrome WebDriver ready")
        return True
    except:
        print("✗ Chrome WebDriver NOT ready")
        print("  Install Chrome browser first")
        return False

def check_test_files():
    """Check if test files exist"""
    files = [
        'comprehensive_e2e_tests.py',
        'requirements.txt',
        'TEST_GUIDE.md'
    ]
    
    all_exist = True
    for f in files:
        path = Path(f)
        if path.exists():
            print(f"✓ {f} found")
        else:
            print(f"✗ {f} NOT found")
            all_exist = False
    
    return all_exist

def main():
    print("=" * 60)
    print("ECOWASTE E2E TEST SUITE - SETUP VERIFICATION")
    print("=" * 60)
    print()
    
    checks = [
        ("Python Version", check_python_version),
        ("Dependencies", check_dependencies),
        ("Test Files", check_test_files),
        ("Server Connection", check_server),
        ("Chrome Browser", check_browser),
    ]
    
    results = []
    for name, check_func in checks:
        print(f"\n[{name}]")
        try:
            result = check_func()
            results.append(result)
        except Exception as e:
            print(f"✗ Error: {e}")
            results.append(False)
    
    print("\n" + "=" * 60)
    if all(results):
        print("✓ ALL CHECKS PASSED - Ready to run tests!")
        print("\nRun tests with:")
        if platform.system() == "Windows":
            print("  run_tests.bat")
        else:
            print("  bash run_tests.sh")
        print("  OR")
        print("  python comprehensive_e2e_tests.py")
        return 0
    else:
        print("✗ Some checks FAILED - Fix issues above before running tests")
        return 1

if __name__ == "__main__":
    sys.exit(main())
