@echo off
color 2
cls
echo ================================================================
echo             INITIALIZING SIEM TESTING UTILITY                   
echo ================================================================
echo.
set /p domain_name="Enter your target Domain Name (e.g., domainwebsite.com): "
echo.
echo Domain set to: %domain_name%
timeout /t 2 >nul

:MENU
cls
echo ================================================================
echo    SIEM / ALERTS SIMULATION TESTING UTILITY [DOMAIN: %domain_name%]          
echo ================================================================
echo  1. Brute Force (12 Failed Attempts)
echo  2. Password Reset Unauthorized
echo  3. Account Re-enable
echo  4. Lateral Movement (Multi-Machine Auth Simulation)
echo  5. Policy Violation (Web Filter Navigation e.g. Pornhub and Eicar)
echo  6. Defense Evasion (Log/History Tampering)
echo  7. Shadow IT (Live Software Installation e.g. nmap,wireshark,steam)
echo  8. Endpoint Threat (Download Only / No Run)
echo  9. Change Domain Name
echo  10. Login in other country using proxy
echo  X. Exit Simulator
echo ================================================================
echo.

set /p choice="Select an alert scenario to simulate [1-10,X]: "

if "%choice%"=="1" goto BRUTEFORCE
if "%choice%"=="2" goto PASSWORDRESET
if "%choice%"=="3" goto ACCOUNTENABLE
if "%choice%"=="4" goto LATERALMOVEMENT
if "%choice%"=="5" goto POLICYVIOLATION
if "%choice%"=="6" goto DEFENSEEVASION
if "%choice%"=="7" goto SHADOWIT
if "%choice%"=="8" goto ENDPOINTTHREAT
if "%choice%"=="9" goto CHANGEDOMAIN
if "%choice%"=="10" goto FOREIGNLOGIN
if "%choice%"=="X" goto EXIT
goto INVALID

:BRUTEFORCE
echo.
echo --- [SIMULATION] Brute Force Authentication Failure ---
set /p target_user="Enter Target Username to attack (e.g., TestUser): "
echo Simulating 12 rapid failed network logons against '%domain_name%\%target_user%'...
for /L %%i in (1,1,12) do (
    net use \\localhost /user:%domain_name%\%target_user% WrongPassword123! >nul 2>&1
)
echo.
echo [SUCCESS] Done! Generated 12 'Event ID 4625' logs for '%domain_name%\%target_user%'.
pause
goto MENU

:PASSWORDRESET
echo.
echo --- [SIMULATION] Unauthorized Password Reset ---
set /p target_user="Enter Target Username to change (e.g., TestUser): "
net user %target_user% TempPassword_999! /domain >nul 2>&1
if %errorlevel% neq 0 (
    echo [NOTE] Command run on client asset. For true domain accounts, run this on the Domain Controller.
    echo [SUCCESS] Inside logs, Target Actor attempted reset for '%domain_name%\%target_user%'.
) else (
    echo.
    echo [SUCCESS] Done! Password reset for '%domain_name%\%target_user%'. Check log for Event ID 4724.
)
pause
goto MENU

:ACCOUNTENABLE
echo.
echo --- [SIMULATION] Account Re-enable ---
set /p target_user="Enter Target Username to enable (e.g., TestUser): "
net user %target_user% /active:yes /domain >nul 2>&1
echo.
echo [SUCCESS] Done! Status update command executed for '%domain_name%\%target_user%'. Look for Event ID 4722.
pause
goto MENU

:LATERALMOVEMENT
echo.
echo --- [SIMULATION] Multi-Machine Lateral Movement ---
set /p target_user="Enter Source Username performing movement: "
set /p mc_list="Enter target machine names or IPs separated by spaces (e.g., PC-SERVER01 127.0.0.2): "
echo Simulating sequential authentication pivots using account '%domain_name%\%target_user%'...
for %%m in (%mc_list%) do (
    echo Attempting connection to %%m...
    net use \\%%m /user:%domain_name%\%target_user% WrongPassword123! >nul 2>&1
)
echo.
echo [SUCCESS] Done! Multi-machine authentication loop complete for '%domain_name%\%target_user%'.
pause
goto MENU

:POLICYVIOLATION
echo.
echo --- [SIMULATION] Policy Violation (Web Filter Navigation) ---
echo  1. Adult Content Navigation (pornhub[.]com)
echo  2. Anti-Malware Test Indicator (eicar[.]org)
echo  3. Entertainment / High-Bandwidth Video (netflix[.]com)
echo  4. Online Gambling Site (bingoplus[.]com)
echo  5. RUN ALL (Execute Simulations 1-4 Sequentially)
echo.
set /p web_choice="Select destination to simulate [1-5]: "

if "%web_choice%"=="1" goto RUN_PORNHUB
if "%web_choice%"=="2" goto RUN_EICAR
if "%choice%"=="3" or "%web_choice%"=="3" goto RUN_NETFLIX
if "%web_choice%"=="4" goto RUN_BINGOPLUS
if "%web_choice%"=="5" goto RUN_ALL_POLICIES
goto INVALID_WEB

:RUN_PORNHUB
echo Generating DNS/HTTP request to pornhub.com...
curl -I -s --max-time 3 http://www.pornhub.com >nul 2>&1
nslookup pornhub.com >nul 2>&1
echo [SUCCESS] Done! Triggered DNS and HTTP headers for unapproved domain tracking.
if "%web_choice%"=="5" goto RUN_EICAR
pause
goto MENU

:RUN_EICAR
echo Requesting standardized EICAR malware string...
curl -s http://www.eicar.org/download/eicar.com >nul 2>&1
nslookup eicar.org >nul 2>&1
echo [SUCCESS] Done! EICAR test string requested to trip endpoint/WAF signatures.
if "%web_choice%"=="5" goto RUN_NETFLIX
pause
goto MENU

:RUN_NETFLIX
echo Generating DNS/HTTP request to netflix.com...
curl -I -s --max-time 3 https://www.netflix.com >nul 2>&1
nslookup netflix.com >nul 2>&1
echo [SUCCESS] Done! Triggered network indicators for streaming media policy validation.
if "%web_choice%"=="5" goto RUN_BINGOPLUS
pause
goto MENU

:RUN_BINGOPLUS
echo Generating DNS/HTTP request to bingoplus.com...
curl -I -s --max-time 3 https://www.bingoplus.com >nul 2>&1
nslookup bingoplus.com >nul 2>&1
echo [SUCCESS] Done! Triggered network indicators for gambling policy validation.
pause
goto MENU

:RUN_ALL_POLICIES
echo.
echo [!] Starting Full Policy Violation Suite...
echo --------------------------------------------------
goto RUN_PORNHUB

:INVALID_WEB
echo.
echo [!] Invalid selection inside web policy menu.
timeout /t 2 >nul
goto MENU

:DEFENSEEVASION
echo.
echo --- [SIMULATION] Defense Evasion (Anti-Forensics) ---
echo  1. Run Attack: Clear Browser History (With Backup to D:\Temp_backup)
echo  2. Run Attack: Wipe Windows Security Logs (With Backup to D:\Temp_backup)
echo  3. REVERT: Restore Browser History and View Saved Event Logs
echo.
set /p evasion_choice="Select evasion tactic [1-3]: "

:: Ensure backup directory exists
mkdir D:\Temp_backup >nul 2>&1

if "%evasion_choice%"=="1" (
    echo [1/3] Backing up Chrome/Edge history objects to D:\Temp_backup...
    copy "%LocalAppData%\Google\Chrome\User Data\Default\History" "D:\Temp_backup\Chrome_History_Bak" /Y >nul 2>&1
    copy "%LocalAppData%\Microsoft\Edge\User Data\Default\History" "D:\Temp_backup\Edge_History_Bak" /Y >nul 2>&1
    
    echo [2/3] Terminating browser instances...
    taskkill /F /IM chrome.exe >nul 2>&1
    taskkill /F /IM msedge.exe >nul 2>&1
    
    echo [3/3] Executing deletion sequence...
    del /f /q "%LocalAppData%\Google\Chrome\User Data\Default\History" >nul 2>&1
    del /f /q "%LocalAppData%\Microsoft\Edge\User Data\Default\History" >nul 2>&1
    echo [SUCCESS] Simulation complete. Original files backed up safely.
)

if "%evasion_choice%"=="2" (
    echo [1/2] Forensically exporting Security Logs to D:\Temp_backup\Live_Security.evtx...
    wevtutil eim Security D:\Temp_backup\Live_Security.evtx >nul 2>&1
    
    echo [2/2] Clearing live active Security Event Log...
    wevtutil cl Security
    if %errorlevel% neq 0 (
        echo [ERROR] Administrative privileges required to clear Windows Security Logs!
    ) else (
        echo [SUCCESS] Done! Live logs cleared (Event ID 1102 generated). Old logs saved to D:\Temp_backup.
    )
)

if "%evasion_choice%"=="3" (
    echo Restoring browser history paths...
    copy "D:\Temp_backup\Chrome_History_Bak" "%LocalAppData%\Google\Chrome\User Data\Default\History" /Y >nul 2>&1
    copy "D:\Temp_backup\Edge_History_Bak" "%LocalAppData%\Microsoft\Edge\User Data\Default\History" /Y >nul 2>&1
    
    echo.
    echo [SUCCESS] Browser files reverted! 
    echo [NOTE] To view your original security logs, open Event Viewer and load:
    echo        "D:\Temp_backup\Live_Security.evtx"
)
pause
goto MENU

:SHADOWIT
echo.
echo --- [SIMULATION] Shadow IT / Live Software Installation ---
echo  1. Download and Install Nmap (Silent Mode)
echo  2. Download and Install Wireshark (Silent Mode)
echo  3. Download and Install Steam Client (Standard Setup)
echo  4. RUN ALL (Sequentially Download and Install All Three)
echo.
set /p sw_choice="Select application installer to deploy [1-4]: "

mkdir C:\Windows\Temp\SimInstallers >nul 2>&1
cd /d C:\Windows\Temp\SimInstallers

if "%sw_choice%"=="1" goto RUN_NMAP
if "%sw_choice%"=="2" goto RUN_WIRESHARK
if "%sw_choice%"=="3" goto RUN_STEAM
if "%sw_choice%"=="4" goto RUN_ALL_SHADOW
goto INVALID_SHADOW

:RUN_NMAP
echo [1/2] Downloading official Nmap Installer...
curl -L -o nmap-setup.exe "https://nmap.org/dist/nmap-7.95-setup.exe" >nul 2>&1
echo [2/2] Executing Nmap installation silently...
start /wait nmap-setup.exe /S
echo [SUCCESS] Nmap installation sequence finished.
if "%sw_choice%"=="4" goto RUN_WIRESHARK
pause
goto MENU

:RUN_WIRESHARK
echo [1/2] Downloading official Wireshark Windows Installer...
curl -L -o wireshark-setup.exe "https://2.test稳定版.wireshark.org/win64/Wireshark-win64-4.2.5.exe" >nul 2>&1
echo [2/2] Executing Wireshark installation silently...
start /wait wireshark-setup.exe /S
echo [SUCCESS] Wireshark installation sequence finished.
if "%sw_choice%"=="4" goto RUN_STEAM
pause
goto MENU

:RUN_STEAM
echo [1/2] Downloading official Steam Client Installer...
curl -L -o SteamSetup.exe "https://cdn.akamai.steamstatic.com/client/installer/SteamSetup.exe" >nul 2>&1
echo [2/2] Launching Steam Setup Window...
:: Note: If running "Run All", this window will pop up. Once handled or closed, the script completes.
start /wait SteamSetup.exe
echo [SUCCESS] Steam installation sequence finished.
goto CLEANUP_SHADOW

:RUN_ALL_SHADOW
echo.
echo [!] Starting Full Shadow IT Installation Suite...
echo --------------------------------------------------
goto RUN_NMAP

:CLEANUP_SHADOW
echo Cleaning up installer cache...
del /f /q C:\Windows\Temp\SimInstallers\* >nul 2>&1
echo.
echo [SUCCESS] All software deployment simulations finished!
pause
goto MENU

:INVALID_SHADOW
echo.
echo [!] Invalid selection inside Shadow IT menu.
timeout /t 2 >nul
goto MENU

:ENDPOINTTHREAT
echo.
echo --- [SIMULATION] Endpoint Threat (File Dropped, NOT Executed) ---
echo This will pull a standardized test signature string down to disk.
echo Note: Your local Antivirus or EDR should immediately quarantine or alert on this file write.
echo.
pause

:: Download file using a mock name indicating a malicious toolkit
curl -s -L -o "C:\Windows\Temp\VirusMaker_DelMe.exe" "https://secure.eicar.org/eicar.com.txt"

echo.
echo Verification: Checking if the file survived or was immediately caught by EDR...
if exist "C:\Windows\Temp\VirusMaker_DelMe.exe" (
    echo [STATUS] File successfully dropped to C:\Windows\Temp\VirusMaker_DelMe.exe without running.
    echo          If your AV/EDR didn't block this, verify your file system inspection policies!
) else (
    echo [STATUS] File is missing! This indicates your active Endpoint protection successfully 
    echo          intercepted, blocked, or quarantined the download upon disk write.
)
pause
goto MENU


:FOREIGNLOGIN
echo.
echo --- [SIMULATION] Suspicious Auth (Login from Another Country) ---
set /p target_user="Enter Target Username to simulate: "
echo.
echo Available Target Proxy Countries:
echo  1. Germany (DE Proxy)
echo  2. United States (US Proxy)
echo.
set /p proxy_choice="Select a foreign origin location [1-2]: "

if "%proxy_choice%"=="1" set "proxy_ip=http://51.89.141.139:80"
if "%proxy_choice%"=="2" set "proxy_ip=http://38.62.217.18:8080"

echo.
echo Sending authentication routing request through %proxy_ip%...
echo This forces the network logs to register a connection from outside your local country.
echo.

:: Using curl to make a web request to an external portal through the proxy
:: (Using your domain name variable inside the user string)
curl -x %proxy_ip% -u "%domain_name%\%target_user%:WrongPassword123!" -m 5 https://httpbin.org/basic-auth/user/passwd >nul 2>&1

if %errorlevel% neq 0 (
    echo [STATUS] Proxy request sent. Check your perimeter Firewall/WAF logs 
    echo          for an outbound authentication attempt originating via proxy routing.
) else (
    echo [SUCCESS] Connection established via foreign proxy server!
)
pause
goto MENU

:CHANGEDOMAIN
echo.
set /p domain_name="Enter NEW target Domain Name: "
echo Domain updated to: %domain_name%
timeout /t 2 >nul
goto MENU

:INVALID
echo.
echo [!] Invalid selection, please pick a number between 1 and 10.
timeout /t 2 >nul
goto MENU

:EXIT
echo.
echo Exiting Simulator. Happy Log Hunting!
timeout /t 2 >nul
exit
