@echo off
setlocal enabledelayedexpansion

rem Set the folder path to the current directory
set "folderPath=."

rem Specify the output text file
set "outputFile=output.txt"

rem Clear the output text file (if it exists)
if exist "%outputFile%" del "%outputFile%"

rem Iterate through PDF files in the current folder and subfolders
for /r "%folderPath%" %%F in (*.pdf) do (
    rem Get the filename
    set "filename=%%~nxF"

    rem Compute MD5 hash
    for /f "delims= " %%H in ('certutil -hashfile "%%~fF" MD5 ^| findstr /i /v "hash"') do (
        set "md5value=%%H"
    )

    rem Compute SHA-256 hash
    for /f "delims= " %%H in ('certutil -hashfile "%%~fF" SHA256 ^| findstr /i /v "hash"') do (
        set "sha256value=%%H"
    )

    rem Output filename and hash values to the output text file
    echo !filename! >> "%outputFile%"
    echo MD5 : !md5value! >> "%outputFile%"
    echo SHA256 : !sha256value! >> "%outputFile%"
    echo. >> "%outputFile%"
)

echo "Output saved to %outputFile%."

pause
