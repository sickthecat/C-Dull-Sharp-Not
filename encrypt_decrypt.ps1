# Functions to save and load secure data
function Save-SecureData($Data, $FilePath) {
    $secureData = [System.Security.Cryptography.ProtectedData]::Protect($Data, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    [System.IO.File]::WriteAllBytes($FilePath, $secureData)
}

function Load-SecureData($FilePath) {
    $secureData = [System.IO.File]::ReadAllBytes($FilePath)
    return [System.Security.Cryptography.ProtectedData]::Unprotect($secureData, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
}

# Load the custom encryption assembly
Add-Type -Path "C:\Users\Public\SimpleAesEncryption.dll"

# Generate or load key and IV
$keyPath = "C:\Users\Public\key.dat"
$ivPath = "C:\Users\Public\iv.dat"

if (-not (Test-Path $keyPath) -or -not (Test-Path $ivPath)) {
    $key = New-Object Byte[] 32
    $iv = New-Object Byte[] 16
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($key)
    [Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($iv)

    Save-SecureData $key $keyPath
    Save-SecureData $iv $ivPath
} else {
    $key = Load-SecureData $keyPath
    $iv = Load-SecureData $ivPath
}

# Create an instance of the encryption class
$encryptor = New-Object SimpleAesEncryption -ArgumentList ($key, $iv)

# Encrypt a command
# Make sure to add the commands you wish to run here:

$commandToEncrypt = "Write-Host 'Hello, World!'"
$encryptedCommand = $encryptor.EncryptString($commandToEncrypt)
Write-Host "Encrypted Command: $encryptedCommand"

# Decrypt the command
$decryptedCommand = $encryptor.DecryptString($encryptedCommand)
Write-Host "Decrypted Command: $decryptedCommand"

# Execute the decrypted command
Invoke-Expression $decryptedCommand

