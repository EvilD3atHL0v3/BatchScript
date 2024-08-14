@echo off
REM This script updates the registry and restarts LanmanServer service

REM Set registry values
echo Setting registry values...

REM Mitigation for CVE-2013-3900 MS13-098
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Wintrust\Config" /v EnableCertPaddingCheck /t REG_SZ /d "1" /f
reg add "HKEY_LOCAL_MACHINE\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config" /v EnableCertPaddingCheck /t REG_SZ /d "1" /f

REM Mitigation for Weak LAN Manager hashing permitted
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\LSA" /v LMCompatibilityLevel /t REG_DWORD /d 5 /f

REM Mitigation for SMBv2 signing not required
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v RequireSecuritySignature /t REG_DWORD /d 1 /f

REM Restart the LanmanServer service
echo Restarting LanmanServer service...
net stop LanmanServer
net start LanmanServer

REM Inform user
echo Registry has been updated and LanmanServer service has been restarted.
pause