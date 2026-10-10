@echo off
chcp 65001 >nul
echo Running Antigravity Auto-Proceed Patch...
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\patch_config.ps1"
echo.
pause
