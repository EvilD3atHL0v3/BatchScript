# Define the paths to the files
$ChromeLoginData = "C:\Users\$env:USERNAME\AppData\Local\Google\Chrome\User Data\Default\Login Data"
$EdgeLoginData = "C:\Users\$env:USERNAME\AppData\Local\Microsoft\Edge\User Data\Default\Login Data"
$FirefoxLoginData = "C:\Users\$env:USERNAME\AppData\Roaming\Mozilla\Firefox\Profiles\{profile}\logins.json"

# Delete each file if it exists
if (Test-Path $ChromeLoginData) {
    Remove-Item $ChromeLoginData -Force
    Write-Host "Deleted Chrome login data."
} else {
    Write-Host "Chrome login data not found."
}

if (Test-Path $EdgeLoginData) {
    Remove-Item $EdgeLoginData -Force
    Write-Host "Deleted Edge login data."
} else {
    Write-Host "Edge login data not found."
}

if (Test-Path $FirefoxLoginData) {
    Remove-Item $FirefoxLoginData -Force
    Write-Host "Deleted Firefox login data."
} else {
    Write-Host "Firefox login data not found."
}
