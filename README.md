sl-android-helper was created to simplify APK management on android devices.

## Features
* Detect connected android devices whether authorized or unauthorized
* Install APK on specific _or_ ALL authorized android devices
* Includes [Minimal ADB](https://forum.xda-developers.com/showthread.php?t=2317790) for convenience

## Instructions

1. Download the [latest release](https://github.com/secretlocation/sl-android-helper/releases) 
1. Unzip the package
1. Copy target APK to the _unzipped_ directory
1. Run **sl-android-helper.exe** and follow the prompts

![Screenshot](/images/screenshot.png)


## Developers

This script was built with PowerShell.

It is compiled to EXE using [PS2EXE-GUI](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5) which is included in the repo.


### TODO
* Add support for uninstalling APKs


### Compiling

1. Run PS2EXE-GUI/Win-PS2EXE.exe
1. Set source file to **sl-android-helper.ps1**
1. DESELECT _"Compile a graphic windows program (parameter -noConsole)"_
1. Click "Compile"
1. **sl-android-helper.exe** will be generated in the same directory as the script

![Win-PS2EXE](/images/Win-PS2EXE.png)


## External Resources
[Minimal ADB](https://forum.xda-developers.com/showthread.php?t=2317790)

[PS2EXE-GUI](https://gallery.technet.microsoft.com/scriptcenter/PS2EXE-GUI-Convert-e7cb69d5)


## MIT License

Copyright (c) 2019 Secret Location https://secretlocation.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
