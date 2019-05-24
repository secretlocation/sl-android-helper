<#
In order to run the script you must first run the command:
Set-ExecutionPolicy Unrestricted

Set back when done testing:
Set-ExecutionPolicy RemoteSigned
#>

$adbPath = ./adb/adb.exe

#create array
$apkArray = @()
$deviceArray = @()

function Init {
    # clear screen
    Clear-Host

    # store initial Device and APK lists
    $deviceArray = GetDeviceList
    $apkArray = GetApkList

    # User selects device
    $_selectedDeviceInfo = PromptForDevice $deviceArray
    if ($_selectedDeviceInfo -eq "ERROR")
    {
        # restart if invalid
        Init
    }
    
    # User selects APK
    $_selectedApkName = PromptForApk $apkArray
    if ($_selectedApkName -eq -1)
    {
        # restart if invalid
        Init
    }
    

    $_installToDeviceId = GetDeviceId $_selectedDeviceInfo
    Write-Host "`nPreparing to install $_selectedApkName to $_installToDeviceId."

    PressEnter
    Write-Host "Installing..."

    # check if system adb exists
    if (Get-Command adb -errorAction SilentlyContinue)
    {
        # use System's adb
        $adbPath = adb
        .\adb\adb.exe -s $_installToDeviceId install -r -t -d -g .\$_selectedApkName
    }
    else{
        # use local adb
        .\adb\adb.exe -s $_installToDeviceId install -r -t -d -g .\$_selectedApkName
    }

    PressEnter
}

function PromptForDevice {
    param(
        $_deviceArray
    )

    # Device Selection
    if ($_deviceArray.count -eq 0){
        Write-Host "No Devices found! Please connect a device...`n" -ForegroundColor Yellow
        Write-Host "Note: Make sure USB debugging is enabled and this PC is authorized.`n" -ForegroundColor DarkYellow
        PressEnter
        $_selectedDeviceInfo = "ERROR"
    }
    elseif($_deviceArray.count -eq 1){
        $_selectedDeviceInfo = $_deviceArray
        
        $_formattedDeviceStr = GetDeviceId $_selectedDeviceInfo
        $_formattedDeviceStr += "`t`t"
        $_formattedDeviceStr += (GetDeviceDescription $_selectedDeviceInfo)

        Write-Host "Found ONE available target device:" -ForegroundColor Green
        Write-Host "Targeting " -ForegroundColor Gray -NoNewLine
        Write-Host $_formattedDeviceStr -ForegroundColor Green
    }
    else
    {
        $_deviceSelection = 0
        $_isValidChoice = 0
        while (!$_isValidChoice) {
            $_deviceSelection = ShowDeviceSelectionList $_deviceArray

            if ($_deviceSelection -ge $_deviceArray.count)
            {
                Clear-Host
                Write-Host "`nDevice not found...`n" -ForegroundColor Red
            }
            elseif ($_deviceSelection -lt 0)
            {
                Clear-Host
                Write-Host "`nNot implemented in this tool yet... Sorry!`n" -ForegroundColor Yellow
            }
            else
            {
                $_isValidChoice = 1
                $_selectedDeviceInfo = $_deviceArray[$_deviceSelection]
            }

        }
    }

    return $_selectedDeviceInfo
}

function PromptForApk {
    param (
        $_apkArray
    )
    # APK Selection
    if ($_apkArray.count -eq 0){
        PressEnter "`nNo APKs - Please make sure it's in this directory..." -ForegroundColor Yellow
        Init
    }
    elseif($_apkArray.count -eq 1){
        $_selectedApkName = $_apkArray
        Write-Host "`nOnly found one APK to use:" -ForegroundColor Green
        Write-Host "Using " -ForegroundColor Gray -NoNewLine
        Write-Host $_selectedApkName -ForegroundColor Green
    }
    else
    {
        $_apkSelection = 0
        $_isValidChoice = 0
        while (!$_isValidChoice) {
            $_apkSelection = ShowApkSelectionList $_apkArray
            $_selectedApkName = $_apkArray[$_apkSelection]
            
            if ($_apkSelection -ge $deviceArray.count)
            {
                Clear-Host
                Write-Host "`nAPK not found...`n" -ForegroundColor Red
            }
            elseif ($_apkSelection -lt 0)
            {
                Clear-Host
                Write-Host "`nAPK not found...`n" -ForegroundColor Red
            }
            else
            {
                $_isValidChoice = 1
            }
        }
    }
    return $_selectedApkName
}
function GetApkList {
    $_fileList = Get-ChildItem -Name

    $_apkArray = @()
    foreach ($line in $_fileList) { 
        if ($line -like "*.apk") {
            $_apkArray += ,$line
        }
    }
    return $_apkArray
}

function GetDeviceList {
    $_deviceList = .\adb\adb.exe devices -l
    
    $_deviceArray = @()

    # Write-Host 'DebugLog: $_deviceList' $_deviceList

    foreach ($device in $_deviceList -split "`r`n") { 
        #check for tab
        If ($device.length -le 1 -or $device -like "*devices*") {
            # ignore description
            # Write-Host 'ignore' $device
        }
        elseif ($device -like "*unauthorized*")
        {
            # Warn
            Write-Host "`nWARNING: Unauthorized device found (check device for prompt):" -ForegroundColor Red
           
            $_id = GetDeviceId $device
            $_info = GetDeviceDescription $device

            Write-Host "`t$_id" -NoNewLine
            Write-Host "`t$_info" -ForegroundColor DarkGray
            Write-Host "`n"

        } else
        {
            # add to list
            # Write-Host '$_deviceArray[]' $device
            $_deviceArray += ,$device
        }
    }

    return $_deviceArray
}

function ShowDeviceSelectionList {
    param (
        $_array
    )

    Write-Host "`nSelect target device(s):`n"

    if ($_array.count -gt 1){
        Write-Host "0) ALL"
    }

    $count = 1
    foreach ($line in $_array) { 
        $_formattedDeviceStr = GetDeviceId $line
        $_formattedDeviceStr += "`t`t"
        $_formattedDeviceStr += (GetDeviceDescription $line)

        Write-Host "$count) $_formattedDeviceStr"
        $count++
    }

    # Write-Host $_array
    $_selection = Read-Host -Prompt "`n`n"
    $_selection -= 1;
    return $_selection
} 

function ShowApkSelectionList {
    param (
        $_array
    )
    
    Write-Host "`nSelect target apk to install:`n"
    # Write-Host $_array
    $count = 1
    foreach ($line in $_array) { 
        Write-Host "$count) $line"
        $count++
    }

    $_selection = Read-Host -Prompt "`n`n"
    $_selection -= 1;
    return $_selection
}

function GetDeviceDescription {
    param (
        $_deviceStr
    )
    
    if($_deviceStr -match "model:\w+"){
        $_formattedInfo = ($matches[0] -split ":")[1]
    }
    
    if($_deviceStr -match "product:\w+"){
        $_formattedInfo += " | "
        $_formattedInfo += ($matches[0] -split ":")[1]
    }

    if ($_deviceStr -match "transport_id:\w+"){
        $_formattedInfo += " | "
        $_formattedInfo += ($matches[0] -split ":")[1]
    }

    return $_formattedInfo
}
function GetDeviceId {
    param (
        $_deviceStr
    )
    if($_deviceStr -match "^\w+"){
        return $matches[0]
    }
}

function PressEnter {
    param (
        $msg
    )
    Write-Host $msg
    Read-Host "Press ENTER to continue..."
}

# run Init
Init