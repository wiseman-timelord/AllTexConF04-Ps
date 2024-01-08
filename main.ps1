# Script main.ps1

# Global Variables
$Global:Config = Import-PowerShellDataFile -Path ".\AllTexConform-Ps\scripts\configuration.psd1"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Global:ToolsDirectory = $scriptPath
$Global:BinDirectory = Join-Path $scriptPath "binaries"
$Global:CacheDirectory = Join-Path $scriptPath "cache"
$Global:DataDirectory = $Global:Config.DataFolderLocation
$Global:TargetResolution = 1024  # Default resolution
$Global:SelectedGPU = 0  # Default GPU

# Imports
. ".\AllTexConform-Ps\scripts\processing.ps1"

# Function to display title
function Show-Title {
    Write-Host "==================( AllTexConFO4-Ps )=================="
}

# Main Menu
function Show-MainMenu {
    Show-Title
    Write-Host "`nWelcome To AllTexConFO4-Ps`n"
    Write-Host "1. Set Data Folder Location"
    Write-Host "2. Set Max Image Resolution"
    Write-Host "3. Set GPU Processor To Use"
    Write-Host "0. Begin Image Processing..."
    Write-Host "`nSelect, Settings=1-3, Begin=0, Exit=X: "
    $choice = Read-Host "Select"
    switch ($choice) {
        "1" { Show-DataFolderMenu }
        "2" { Show-ResolutionMenu }
        "3" { Show-GPUSelectionMenu }
        "0" { InitiateTextureProcessing $Global:TargetResolution }
        "X" { Write-Host "Exiting..."; return }
        default { Write-Host "Invalid option, please try again"; Show-MainMenu }
    }
}

# Data Folder Menu
function Show-DataFolderMenu {
    Show-Title
    Write-Host "Current Data Folder Location: $($Global:DataDirectory)"
    Write-Host "1. Use Current Location"
    Write-Host "2. Enter New Data Folder Location"
    Write-Host "B. Back"
    $choice = Read-Host "Select"
    switch ($choice) {
        "1" { }
        "2" { 
            $newDataFolder = Read-Host "Enter the absolute path to the Fallout 4 Data Directory"
            $Global:Config.DataFolderLocation = $newDataFolder
            $Global:DataDirectory = $newDataFolder
        }
        "B" { Show-MainMenu }
        default { Write-Host "Invalid option, please try again"; Show-DataFolderMenu }
    }
}

# Resolution Menu
function Show-ResolutionMenu {
    Show-Title
    Write-Host "Current Max Image Resolution: $($Global:TargetResolution)"
    Write-Host "1. Set to 512x"
    Write-Host "2. Set to 1024x"
    Write-Host "3. Set to 2048x"
    Write-Host "B. Back"
    $choice = Read-Host "Select"
    switch ($choice) {
        "1" { $Global:TargetResolution = 512; Show-MainMenu }
        "2" { $Global:TargetResolution = 1024; Show-MainMenu }
        "3" { $Global:TargetResolution = 2048; Show-MainMenu }
        "B" { Show-MainMenu }
        default { Write-Host "Invalid option, please try again"; Show-ResolutionMenu }
    }
}

# Get GPU List
function Get-GPUList {
    $texconvOutput = & $Global:TexConvExecutable --help
    $gpuList = $texconvOutput -match "^   [0-9]: VID" -replace '   ', ''
    return $gpuList
}

# Display GPU Selection
function Show-GPUSelectionMenu {
    $gpuList = Get-GPUList
    Write-Host "Select GPU for Texture Processing:"
    $gpuList | ForEach-Object { Write-Host $_ }
    $Global:SelectedGPU = Read-Host "Enter the number of your choice"
}

# Start Script
Set-Location -Path $scriptPath
Show-MainMenu
