# PowerShell Encryption Script

## Overview

PowerShell script and a C# class that together provide a simple yet effective way to encrypt and decrypt commands in PowerShell using AES encryption. The solution is designed for scenarios where you need to execute encrypted PowerShell commands securely.
If you know of a better way to do this, let me know. 
It's babies first C# over here with a little bit of help from our buddy Adderall.
With great amphetamines come great responsibility.

### Components

- **SimpleAesEncryption.cs**: A C# class that handles AES encryption and decryption.
- **encrypt_decrypt.ps1**: A PowerShell script that uses the compiled C# DLL to encrypt and decrypt a sample command.
- **Key and IV Storage**: Securely stored in `.dat` files using the Windows Data Protection API (DPAPI).

## Getting Started

### Prerequisites

- Windows operating system (the script uses Windows-specific features).
- PowerShell.
- A C# compiler (like `csc.exe` included with .NET SDK or VisualStudio).

### Setting Up

1. **Compile the C# Class into a DLL**: 
   
   Use the provided `SimpleAesEncryption.cs` to create a DLL. This can be done using `csc.exe`:

   ```bash
   csc.exe /target:library /out:SimpleAesEncryption.dll SimpleAesEncryption.cs
   ```

2. **Running the PowerShell Script**:

   - Update the script `encrypt_decrypt.ps1` with the path of the compiled DLL.
   - On the first run, the script will generate a random key and IV, encrypt them using DPAPI, and store them in `.dat` files.
   - On subsequent runs, it will use the stored key and IV for consistent encryption/decryption.

### Usage

Run `encrypt_decrypt.ps1` via PowerShell. It will automatically handle the encryption of a sample command (`Write-Host 'Hello, World!'`), decrypt it, and execute it. Feel free to modify the script to encrypt/decrypt your specific commands.

## Security

- The AES key and IV are securely generated and stored using the Windows Data Protection API, ensuring that they can only be accessed by the same user or machine.
- The `.dat` files contain the encrypted key and IV in a binary format, which isn't human-readable and is secure under the user's Windows account.

### Note on Security

While this method provides a good security level for individual users or specific machines, it might not be suitable for high-security requirements or multi-user environments. For such scenarios, consider using more advanced key management solutions.

## Contributing

Feel free to fork this repository and contribute to its development. If you have any suggestions, improvements, or issues, please open a pull request or an issue.

## License

This project is open-sourced under the [WTFMSL]. (What the fuck, Microsoft License)
I honestly don't give a fuck what you do with this shit, just don't fucking @ me.

    PowerShell AES Encryption Basics from CodeAndKeep.Com:
        URL: https://codeandkeep.com/PowerShell-Aes-Encryption

    Secure String Handling and DPAPI from fausto.io:
        URL: https://web.archive.org/web/20220103225111/https://fausto.io/powershell/2021/06/28/encrypting-and-decrypting-passwords-in-files-with-powershell-7-1/

    AES Encryption and Decryption Functions from Michls Tech Blog:
        URL: https://michlstechblog.info/blog/powershell-en-and-decrypt-string-with-aes256/

---

Fuck C#! 



