@echo off
setlocal enabledelayedexpansion

rem Set the folder path to the current directory
set "folderPath=."

rem Initialize variables to store the last file processed
set "lastFile="

rem Iterate through PDF files in the current folder
for %%F in ("%folderPath%\*.pdf") do (
    rem Update the last file processed
    set "lastFile=%%F"
)

rem If last file is set (i.e., at least one PDF file was found), process it
if defined lastFile (
    rem Get the filename
    set "filename=!lastFile!"

    rem Compute SHA1 hash
    for /f "delims= " %%H in ('certutil -hashfile "!lastFile!" ^| findstr /i /v "hash"') do (
        set "sha1value=%%H"
    )

    rem Compute MD5 hash
    for /f "delims= " %%H in ('certutil -hashfile "!lastFile!" MD5 ^| findstr /i /v "hash"') do (
        set "md5value=%%H"
    )


    rem Compute SHA-256 hash
    for /f "delims= " %%H in ('certutil -hashfile "!lastFile!" SHA256 ^| findstr /i /v "hash"') do (
        set "sha256value=%%H"
    )

    rem Output filename and hash values to the command prompt
    echo Filename: !filename!
    echo Hash Value :
    echo SHA1 - !sha1value!
    echo MD5 - !md5value!
    echo SHA256 - !sha256value!
) else (
    rem If no PDF files were found, display a message
    echo No PDF files found in "%folderPath%".
)

pause
