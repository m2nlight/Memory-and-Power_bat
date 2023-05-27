@echo off
net session >nul 2>&1 || start "" powershell "start-process '%~s0' -verb runas" && goto :eof

:BEGIN
cls
echo ==============================
echo 1. Disable SysMain Service
echo 2. Enable SysMain Service
echo.
echo 3. Disable Memory Compression (*)
echo 4. Enable Memory Compression
echo.
echo 5. Disable prefetching (**)
echo 6. Enable prefetching
echo.
echo 7. Disable Windows Search Service (**)
echo 8. Enable Windows Search Service
echo.
echo 9. Get-MMAgent
echo.
echo 0. EXIT
echo ==============================
echo.
echo ^ * Good for CPU
echo ** Good for SSD
echo.
choice /c 1234567890 /m "Choise:" 

if ERRORLEVEL 10 goto :END
goto :L%errorlevel%

:L1
net stop SysMain
sc config SysMain start= Disabled
pause
goto :BEGIN

:L2
sc config SysMain start= Auto
net start SysMain
pause
goto :BEGIN

:L3
powershell Disable-MMAgent -mc
pause
goto :BEGIN

:L4
powershell Enable-MMAgent -mc
pause
goto :BEGIN

:L5
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f>nul 2>nul
powershell Disable-MMAgent -apl
pause
goto :BEGIN

:L6
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 3 /f>nul 2>nul
powershell Enable-MMAgent -apl
pause
goto :BEGIN

:L7
net stop WSearch
sc config WSearch start= Disabled
pause
goto :BEGIN

:L8
sc config WSearch start= Auto
net start WSearch
pause
goto :BEGIN

:L9
powershell Get-MMAgent
pause
goto :BEGIN

:END
