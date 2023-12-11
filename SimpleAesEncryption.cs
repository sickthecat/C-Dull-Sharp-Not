using System;
using System.IO;
using System.Security.Cryptography;
using System.Text;

public class SimpleAesEncryption
{
    private readonly AesManaged _aesManaged;

    public SimpleAesEncryption(byte[] key, byte[] iv)
    {
        _aesManaged = new AesManaged
        {
            Key = key,
            IV = iv
        };
    }

    public string EncryptString(string plainText)
    {
        byte[] encrypted;
        ICryptoTransform encryptor = _aesManaged.CreateEncryptor(_aesManaged.Key, _aesManaged.IV);

        using (MemoryStream msEncrypt = new MemoryStream())
        {
            using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
            {
                using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                {
                    swEncrypt.Write(plainText);
                }
                encrypted = msEncrypt.ToArray();
            }
        }

        return Convert.ToBase64String(encrypted);
    }

    public string DecryptString(string cipherText)
    {
        string plaintext = null;
        byte[] cipherBytes = Convert.FromBase64String(cipherText);
        ICryptoTransform decryptor = _aesManaged.CreateDecryptor(_aesManaged.Key, _aesManaged.IV);

        using (MemoryStream msDecrypt = new MemoryStream(cipherBytes))
        {
            using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
            {
                using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                {
                    plaintext = srDecrypt.ReadToEnd();
                }
            }
        }

        return plaintext;
    }
}
