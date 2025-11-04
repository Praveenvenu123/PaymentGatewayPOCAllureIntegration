@echo off
REM ==============================
REM Run Robot Framework with Allure Listener
REM ==============================

set PROJECT_DIR=%~dp0
set RESULTS_DIR=%PROJECT_DIR%allure-results

echo Deleting old Allure results...
if exist "%RESULTS_DIR%" rmdir /s /q "%RESULTS_DIR%"

echo Running Robot tests...
robot --listener "allure_robotframework;%RESULTS_DIR%" "%PROJECT_DIR%Tests"

if %errorlevel% neq 0 (
    echo.
    echo ❌ Tests failed. Check log.html for details.
) else (
    echo.
    echo ✅ Tests completed successfully.
)

REM ==============================
REM Generate and open Allure report
REM ==============================
echo.
echo Generating Allure report...
allure serve "%RESULTS_DIR%"
