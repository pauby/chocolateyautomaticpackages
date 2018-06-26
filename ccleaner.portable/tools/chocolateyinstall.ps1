﻿$ErrorActionPreference = 'Stop'

$packageName = 'ccleaner.portable'
$url32       = 'https://www.piriform.com/ccleaner/download/portable/downloadfile'
$checksum32  = '1aaa0621ee295147d82f168b4cdc0151dd1507d4624aa2ac5aa28eb1a6c5d93a'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$bits = Get-ProcessorBits
$ccleaner_temp = "$env:USERPROFILE\ccleaner_temp"

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}


Install-ChocolateyZipPackage @packageArgs

if($bits -ne 64)
    {
    $FileFullPath = get-childitem $toolsPath -recurse -include *.exe | select -First 1
    }
else
    {
    $FileFullPath = get-childitem $toolsPath -recurse -include *64*.exe | select -First 1
    }

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\CCleaner.lnk" $FileFullPath

if(Test-Path $ccleaner_temp)
    {
    Move-Item (Get-ChildItem $ccleaner_temp) -Destination $toolsPath -Force
    }
