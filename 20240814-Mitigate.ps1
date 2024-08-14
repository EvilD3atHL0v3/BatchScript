# Add registry values

# Mitigation the vulnerability of CVE-2013-3900 MS13-098: Vulnerability in Windows Could Allow Remote Code Execution
New-ItemProperty -Path "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config" -Name "EnableCertPaddingCheck" -Value "1" -PropertyType String
New-ItemProperty -Path "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config" -Name "EnableCertPaddingCheck" -Value "1" -PropertyType String

# Mitigation the vulnerability of Weak LAN Manager hashing permitted
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\LSA" -Name "LMCompatibilityLevel" -Value 5 -PropertyType DWord