@echo off
net session >nul 2>&1 || start "" powershell "start-process '%~s0' -verb runas" && goto :eof

:BEGIN
cls
echo ==============================
echo 1. Disable SysMain Service           5. Disable prefetching (**)
echo 2. Enable SysMain Service            6. Enable prefetching
echo.
echo 3. Disable Memory Compression (*)    7. Disable Windows Search Service (**)
echo 4. Enable Memory Compression         8. Enable Windows Search Service
echo.
echo 9. Get-MMAgent
echo.
echo a. Turn hibernate off and fast startup off (**)
echo b. Turn hibernate on and fast startup off (**)
echo c. Turn hibernate on and fast startup on
echo.
echo d. Power Mode: High performance
echo e. Power Mode: Ultimate performance
echo f. Power Mode: Balanced (Default)
echo h. Power Mode: Power saver
echo.
echo 0. EXIT
echo ==============================
echo.
echo ^ * Good for CPU
echo ** Good for SSD
echo.
choice /c 123456789abcdefh0 /m "Choise:" 

if ERRORLEVEL 17 goto :END
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

:L10
echo Turn hibernate off and fast startup off
powercfg /hibernate off
pause
goto :BEGIN

:L11
echo Turn hibernate on and fast startup off
powercfg /hibernate on
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 0 /f>nul 2>nul
pause
goto :BEGIN

:L12
echo Turn hibernate on and fast startup on
powercfg /hibernate on
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v "HiberbootEnabled" /t REG_DWORD /d 1 /f>nul 2>nul
pause
goto :BEGIN

:L13
powercfg -s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
powercfg -l
pause
goto :BEGIN

:L14
powercfg -s e9a42b02-d5df-448d-aa00-03f14749eb61
powercfg -l
pause
goto :BEGIN

:L15
powercfg -s 381b4222-f694-41f0-9685-ff5bb260df2e
powercfg -l
pause
goto :BEGIN

:L16
powercfg -s a1841308-3541-4fab-bc81-f71556f20b4a
powercfg -l
pause
goto :BEGIN

:END
