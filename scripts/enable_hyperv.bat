@echo off
REM Pemanggil enable_hyperv.ps1. Skrip akan meminta hak Administrator (UAC).
REM Opsi: -Force -DisableVBS -Restart -NoReboot
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0enable_hyperv.ps1" %*
echo.
echo Tekan sembarang tombol untuk menutup jendela ini.
pause >nul
