# Script: main.ps1

# Global Variables
$Global:Config = Import-PowerShellDataFile -Path ".\AllTexConform-Ps\scripts\configuration.psd1"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Global:ToolsDirectory = $scriptPath
$Global:BinDirectory = Join-Path $scriptPath "binaries"
$Global:CacheDirectory = Join-Path $scriptPath "cache"
$Global:DataDirectory = $Global:Config.DataFolderLocation

# Imports
. ".\AllTexConform-Ps\scripts\processing.ps1"

# Function to display title
function Show-Title {
    Write-Host "==================( AllTexConFO4-Ps )=================="
}

# Function for MainMenu
function Show-MainMenu {
    Show-Title
    Write-Host "             `nWelcome To AllTexConFO4-Ps`n"
    $choice = Read-Host "Select, Begin=1-0+A-W+Y-Z , Exit=X: "
    if ($choice -ne "X") {
        Show-FoldersMenu
        Show-ResolutionMenu
    }
    else {
        Write-Host "Exiting..."
    }
}

# Function for Folders Menu
function Show-FoldersMenu {
    Show-Title
    Write-Host "Previous Location: $($Global:Config.DataFolderLocation)"
    Write-Host "1. Use Previous Location"
    Write-Host "2. Enter Data Folder Location"
    Write-Host "X. Exit"
    $choice = Read-Host "Select, Options=1-2, Exit=X"
    switch ($choice) {
        "1" { }
        "2" { 
            $newDataFolder = Read-Host "Enter the absolute path to the Fallout 4 Data Directory"
            $Global:Config.DataFolderLocation = $newDataFolder
            $Global:DataDirectory = $newDataFolder
        }
        "X" { Write-Host "Exiting..."; return }
        default { Write-Host "Invalid option, please try again"; Show-FoldersMenu }
    }
}

# Function for Resolution Menu
function Show-ResolutionMenu {
    Show-Title
    Write-Host "1. Process Textures at 512x Resolution"
    Write-Host "2. Process Textures at 1024x Resolution"
    Write-Host "3. Process Textures at 2048x Resolution"
    Write-Host "4. Back"
    $choice = Read-Host "Please select an option"
    switch ($choice) {
        "1" { Show-GPUSelectionMenu; Process-Textures "512" }
        "2" { Show-GPUSelectionMenu; Process-Textures "1024" }
        "3" { Show-GPUSelectionMenu; Process-Textures "2048" }
        "4" { Show-MainMenu }
        default { Write-Host "Invalid option, please try again"; Show-ResolutionMenu }
    }
}

# Function for FoldersMenu
function Show-FoldersMenu {
    Show-Title
    $prevLocation = $Global:Config.DataFolderLocation
    Write-Host "Previous Location: $prevLocation`n"
    Write-Host "1. Use Previous Location"
    Write-Host "2. Enter Data Folder Location"
    Write-Host "`nEnter Options=1-2, Exit=X: "
    $choice = Read-Host "Select"
    switch ($choice) {
        "1" { 
            if ($prevLocation -eq "First Run - Set This NOW") {
                Write-Host "No previous location set. Please enter a location."
                Show-FoldersMenu
            } else {
                $Global:DataDirectory = $prevLocation
                Show-ResolutionMenu
            }
        }
        "2" {
            $newLocation = Read-Host "Enter the absolute path to the Data Folder"
            $Global:Config.DataFolderLocation = $newLocation
            $Global:DataDirectory = $newLocation
            Show-ResolutionMenu
        }
        "X" { Write-Host "Exiting..."; return }
        default { Write-Host "Invalid option, please try again"; Show-FoldersMenu }
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
