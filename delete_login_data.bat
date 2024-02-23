@echo off

:: This line is to set the default location of file

set "chromeLoginData=C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Login Data"
set "edgeLoginData=C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\Default\Login Data"

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

setlocal
:: --------------------------------------------------------------------------------
set "firefoxProfileDir=C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles"

for /f "delims=" %%I in ('dir /b /ad "%firefoxProfileDir%"') do (
    if exist "%firefoxProfileDir%\%%I\logins.json" (
        del "%firefoxProfileDir%\%%I\logins.json"
        echo Firefox Login Data in profile %%I deleted successfully.
    ) else (
        echo Firefox Login Data not found in profile %%I.
    )
)
:: --------------------------------------------------------------------------------

exit
