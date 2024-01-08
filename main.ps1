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
    Write-Host "`nMain Menu`n"
    Write-Host "1. Set Data Folder Location"
    Write-Host "2. Set Max Image Resolution"
    Write-Host "3. Set GPU Processor To Use"
    Write-Host "`nSelect, Settings=1-3, Begin=B, Exit=X: "
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
    Write-Host "`nFolders Menu`n"
    Write-Host "Current Data Folder Location: $($Global:DataDirectory)"
    Write-Host "1. Enter New Data Folder Location"
    $choice = Read-Host "`nSelect, Options 1, Main Menu=M"
    switch ($choice) {
        "1" { 
            $newDataFolder = Read-Host "Enter the absolute path to the Fallout 4 Data Directory"
            $Global:Config.DataFolderLocation = $newDataFolder
            $Global:DataDirectory = $newDataFolder
        }
        "M" { Show-MainMenu }
        default { Write-Host "Invalid option, please try again"; Show-DataFolderMenu }
    }
}

# Resolution Menu
function Show-ResolutionMenu {
    Show-Title
    Write-Host "`nFormat Menu`n"
    Write-Host "Current: $($Global:TargetResolution)"
    Write-Host "1. Set Max Res To 512x"
    Write-Host "2. Set Max Res To 1024x"
    Write-Host "3. Set Max Res To 2048x"
    $choice = Read-Host "`nSelect, Options 1-3, Main Menu=M"
    switch ($choice) {
        "1" { $Global:TargetResolution = 512; Show-ResolutionMenu }
        "2" { $Global:TargetResolution = 1024; Show-ResolutionMenu }
        "3" { $Global:TargetResolution = 2048; Show-ResolutionMenu }
        "M" { Show-MainMenu }
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
    Show-Title
    Write-Host "`nGPU Menu`n"
    $gpuList = Get-GPUList
    Write-Host "`nSelect GPU for Texture Processing:"
    foreach ($gpu in $gpuList) {
        Write-Host $gpu
    }
    Write-Host "M. Return to Main Menu"

    $choice = Read-Host "`nSelect, GPU=1-9, Main Menu=M"
    
    if ($choice -eq 'M') {
        Show-MainMenu
    } elseif ($choice -in $gpuList) {
        $Global:SelectedGPU = $choice
    } else {
        Write-Host "Invalid option, please try again"
        Show-GPUSelectionMenu
    }
}


# Start Script
Set-Location -Path $scriptPath
Show-MainMenu
