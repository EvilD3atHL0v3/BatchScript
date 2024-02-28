@echo off
set destinationFolder="C:\Backup_LogData"
set "chromeLoginData=C:\Users\%USERNAME%\AppData\Local\Google\Chrome\User Data\Default\Login Data"
set "edgeLoginData=C:\Users\%USERNAME%\AppData\Local\Microsoft\Edge\User Data\Default\Login Data"
set "firefoxProfileDir=C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles"
set destinationFolder1="C:\Backup_LogData\Chrome"
set destinationFolder2="C:\Backup_LogData\Edge"

:: Check if destination folder exists, create if not
if not exist %destinationFolder% (
mkdir %destinationFolder% 
mkdir "%destinationFolder%\Chrome" 2>nul
mkdir "%destinationFolder%\Edge" 2>nul  
)

	if exist "%chromeLoginData%" (
    	copy "%chromeLoginData%" "%destinationFolder1%"
	echo Chrome Login Data was successfully archive in %destinationFolder1%
	) else (
    	echo Chrome Login Data not found.
	)

	if exist "%edgeLoginData%" (
    	copy "%edgeLoginData%" "%destinationFolder2%"
    	echo Edge Login Data  was successfully archive in %destinationFolder2%
	) else (
    	echo Edge Login Data not found.
	)

	setlocal
	:: --------------------------------------------------------------------------------
	

	for /f "delims=" %%I in ('dir /b /ad "%firefoxProfileDir%"') do (
    		if exist "%firefoxProfileDir%\%%I\logins.json" (
        	copy "%firefoxProfileDir%\%%I\logins.json" %destinationFolder%
        	echo Firefox Login Data was successfully archive in %destinationFolder%
    		) else (
        	echo Firefox Login Data not found in profile %%I.
    		)
	)    


:end
pause
