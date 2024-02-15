@echo off

:: This line is to set the default location of file

set "chromeLoginData=C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Login Data"
set "edgeLoginData=C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\Default\Login Data"
set "firefoxLoginData=C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles\{profile}\logins.json"

if exist "%chromeLoginData%" (
    del "%chromeLoginData%"
    echo Chrome Login Data deleted successfully.
) else (
    echo Chrome Login Data not found.
)

if exist "%edgeLoginData%" (
    del "%edgeLoginData%"
    echo Edge Login Data deleted successfully.
) else (
    echo Edge Login Data not found.
)

if exist "%firefoxLoginData%" (
    del "%firefoxLoginData%"
    echo Firefox Login Data deleted successfully.
) else (
    echo Firefox Login Data not found.
)

exit
