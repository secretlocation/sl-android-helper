This utility to make APK management on android devices easier.

## Instructions

1. Download the [latest release](https://github.com/secretlocation/sl-android-helper/releases) 
1. Unzip the package
1. Copy target APK to the _unzipped_ directory
1. Run **sl-android-helper.exe** and follow the prompts

![Screenshot](/images/screenshot.png)

## Features
* Detect connected android devices whether authorized or unauthorized
* Install APK on specific _or_ ALL authorized android devices

## TODO
* Add support for uninstalling APKs

## Developers

This script was built with PowerShell.

It is compiled to EXE using [PS2EXE-GUI](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5) which is included in the repo.

### Compiling

1. Run PS2EXE-GUI/Win-PS2EXE.exe
1. Set source file to **sl-android-helper.ps1**
1. DESELECT _"Compile a graphic windows program (parameter -noConsole)"_
1. Click "Compile"
1. **sl-android-helper.exe** will be generated in the same directory as the script

![Win-PS2EXE](/images/Win-PS2EXE.png)
