# EXE to .intunewin
This Windows batch file pulls the latest version of the [Microsoft content prep tool](https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool) from GitHub and converts your setup files into a **.intunewin** format, which can be directly uploaded to Microsoft Endpoint Manager.

## Features
- [x] Downloads the latest version of the content prep tool
- [x] Easy drag and drop of setup files for creating setup
- [x] Creates a **.intunewin** file, ready for upload to Microsoft Endpoint Manager
- [x] Takes .MSI or .EXE as input
- [ ] Error handling

## Disclaimer
Before you install and the use Microsoft Win32 Content Prep Tool you must:

- Review the Microsoft License Terms for Microsoft Win32 Content Prep Tool. Print and retain a copy of the license terms for your records. By downloading and using Microsoft Win32 Content Prep Tool, you agree to such license terms. If you do not accept them, do not use the software.
- Review the Microsoft Intune Privacy Statement for information on the privacy policy of the Microsoft Win32 Content Prep Tool.

*Note: The generated .intunewin file contains all compressed and encrypted source setup files and the encryption information to decrypt it. Please keep it in the safe place as your source setup files.*
