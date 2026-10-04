@echo off
title Custom Nodes Real-time Sync Engine
color 0A
cls

:: =========================================================
:: CONFIGURATION - UPDATE TARGET BACKUP / CLOUD PATH HERE
:: =========================================================
set "SOURCE=%~dp0"
set "TARGET=D:\Path\To\Destination\Folder"

echo ==================================================
echo   🚀 REAL-TIME CUSTOM NODE SYNC ENGINE
echo   Source: %SOURCE%
echo   Target: %TARGET%
echo ==================================================
echo.

:INITIAL_SYNC
echo [%TIME%] 🔄 Performing immediate initial sync for all node folders...

if not exist "%TARGET%" mkdir "%TARGET%"

for /D %%F in ("%SOURCE%*") do (
    echo    -> Syncing: "%%~nxF"...
    robocopy "%%F" "%TARGET%\%%~nxF" /MIR /XO /FFT /R:1 /W:1 /NDL /NFL /NJH /NJS
)

echo [%TIME%] ✅ Initial sync complete!
echo.
echo ==================================================
echo   ⚡ Live File System Monitoring Active
echo   Status: Idle (0%% CPU). Waiting for changes...
echo ==================================================
echo.

:MONITOR_LOOP
:: Robocopy /MON:1 /MOT:1 hooks OS-level change notifications (0% CPU idle)
for /D %%F in ("%SOURCE%*") do (
    robocopy "%%F" "%TARGET%\%%~nxF" /MIR /XO /FFT /MON:1 /MOT:1 /R:1 /W:1 /NDL /NFL /NJH /NJS >nul
)
goto MONITOR_LOOP