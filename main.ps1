# Script: main.ps1

# Imports
. ".\scripts\impexppsd1.ps1"
. ".\scripts\processing.ps1"
. ".\scripts\display.ps1"
. ".\scripts\artwork.ps1"
. ".\scripts\utility.ps1"

# Variables
$Global:Config = Import-PowerShellData1 -Path ".\scripts\settings.psd1"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Global:ToolsDirectory = $scriptPath
$Global:BinDirectory = Join-Path $scriptPath "binaries"
$Global:BSArch64Executable = Join-Path $Global:BinDirectory "BSArch64.exe"
$Global:TexConvExecutable = Join-Path $Global:BinDirectory "texconv.exe"
$Global:TexDiagExecutable = Join-Path $Global:BinDirectory "texdiag.exe"
$Global:CacheDirectory = Join-Path $scriptPath "cache"

# Apply settings from the configuration file
$Global:DataDirectory = $Global:Config.DataFolderLocation
$Global:TargetResolution = $Global:Config.TargetResolution
$Global:SelectedGPU = $Global:Config.GpuCardSelectionNumber
$Global:UseMultithreading = $Global:Config.ArchiveMultithreading
$Global:ProcessCharacterTextures = $Global:Config.ProcessCharacterTextures
$Global:AvailableResolutions = @(512, 1024, 2048)

# Initialize other global variables
$Global:MenuColumnWidth = 64
$Global:ProcessingStartTime = $null
$Global:ProcessingEndTime = $null
$Global:FilesProcessed = 0
$Global:FilesPassed = 0
$Global:PreviousDataSize = 0
$Global:ResultingDataSize = 0


# Entry Point
Set-Location -Path $scriptPath
$Global:GpuList = Get-GPUList
Show-ConfigurationMenu
