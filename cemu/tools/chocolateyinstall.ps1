﻿$ErrorActionPreference = 'Stop'

$packageName = 'cemu'
$url32       = 'http://cemu.info/releases/cemu_1.20.2.zip'
$checksum32  = '7e9ad0e1b5de36ca4affb5d95c0c00d6cbcdafa6e9fd892215ce96df3bdd0a39'
$toolsPath   = Split-Path $MyInvocation.MyCommand.Definition
$cemu_folder = "$(Get-ToolsLocation)\cemu"

$packageArgs = @{
  packageName    = $packageName
  url            = $url32
  checksum       = $checksum32
  checksumType   = 'sha256'
  unzipLocation  = $toolsPath
}

If (Get-Item "$env:ChocolateyInstall\lib-bkp\cemu\tools\cemu\Cemu.exe" -ErrorAction SilentlyContinue) {
	Write-Output "Migrating cemu location to $cemu_folder"
	Move-Item "$env:ChocolateyInstall\lib-bkp\cemu\tools\cemu" "$(Get-ToolsLocation)" -Force
	Remove-Item "$env:ChocolateyInstall\lib\cemu\tools\cemu" -Recurse -Force -ErrorAction SilentlyContinue
}

Install-ChocolateyZipPackage @packageArgs

$latest = (Get-ChildItem $toolsPath -Recurse -ErrorAction SilentlyContinue | Where-Object {$_.Name -like '*cemu*'} | sort {$_.CreationTime} | select -First 1).FullName
Robocopy "$latest" "$cemu_folder" /R:0 /W:0 /E /XO
Remove-Item "$latest" -Recurse -Force -ErrorAction SilentlyContinue

Install-ChocolateyShortcut -shortcutFilePath "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\CEMU.lnk" "$cemu_folder\cemu.exe" -WorkingDirectory "$cemu_folder"

