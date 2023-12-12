# Load necessary assemblies
Add-Type -AssemblyName System.Security
Add-Type -Path "C:\Users\stc\Desktop\test\SimpleAesEncryption.dll"

# Functions to save and load secure data using DPAPI (Windows Data Protection API)
function Save-SecureData($Data, $FilePath) {
    $secureData = [System.Security.Cryptography.ProtectedData]::Protect($Data, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    [System.IO.File]::WriteAllBytes($FilePath, $secureData)
}

function Load-SecureData($FilePath) {
    $secureData = [System.IO.File]::ReadAllBytes($FilePath)
    return [System.Security.Cryptography.ProtectedData]::Unprotect($secureData, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
}

# Generate or load key and IV
$keyPath = "C:\Users\stc\Desktop\test\key.dat"
$ivPath = "C:\Users\stc\Desktop\test\iv.dat"

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

# Create an instance of the SimpleAesEncryption class
$encryptor = New-Object SimpleAesEncryption -ArgumentList ($key, $iv)

# Encrypt a command
$commandToEncrypt = "Write-Host 'Hello, World!'"
try {
    $encryptedCommand = $encryptor.EncryptString($commandToEncrypt)
    Write-Host "Encrypted Command: $encryptedCommand"
} catch {
    Write-Error "Error encrypting command: $_"
}

# Decrypt the command
try {
    $decryptedCommand = $encryptor.DecryptString($encryptedCommand)
    Write-Host "Decrypted Command: $decryptedCommand"
} catch {
    Write-Error "Error decrypting command: $_"
}

# Execute the decrypted command
try {
    Invoke-Expression $decryptedCommand
} catch {
    Write-Error "Error executing command: $_"
}
