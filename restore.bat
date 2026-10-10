@echo off
chcp 65001 >nul
echo Running Antigravity Auto-Proceed Restore...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\restore_config.ps1"
echo.
pause
