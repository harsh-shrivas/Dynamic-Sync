@echo off
echo Stopping Dynamic Sync instances...
taskkill /F /IM robocopy.exe /T 2>nul
taskkill /F /FI "WINDOWTITLE eq Dynamic Sync*" /T 2>nul
echo All sync processes terminated.
pause