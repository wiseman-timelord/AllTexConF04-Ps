# Script: main.ps1

# Global Variables
$Global:Config = Import-PowerShellDataFile -Path ".\AllTexConform-Ps\scripts\conf-data.psd1"
$Global:RootDirectory = "..\"
$Global:ToolsDirectory = ".\AllTexConform-Ps"
$Global:BinDirectory = ".\AllTexConform-Ps\binaries"
$Global:CacheDirectory = ".\AllTexConform-Ps\cache"
$Global:DataDirectory = ".\Data"
$Global:TexturesDirectory = ".\Data\Textures"
$Global:ExcludeDirectory = ".\AllTexConform-Ps\Cache\Data\Textures\actors\character"
$Global:TexConvExecutable = ".\AllTexConform-Ps\binaries\texconv.exe"
$Global:TexDiagExecutable = ".\AllTexConform-Ps\binaries\texdiag.exe"
$Global:SevenZipExecutable = ".\AllTexConform-Ps\binaries\7za.exe"

# Import processing functions
. ".\AllTexConform-Ps\scripts\processing.ps1"

# Function to display title
function Show-Title {
    Write-Host "==================( AllTexConFO4-Ps )=================="
}

# Function for Main Menu
function Show-MainMenu {
    Show-Title
    Write-Host "1. Process Textures at 512x Resolution"
    Write-Host "2. Process Textures at 1024x Resolution"
    Write-Host "3. Process Textures at 2048x Resolution"
    Write-Host "4. Exit"
    $choice = Read-Host "Please select an option"
    switch ($choice) {
        "1" { Show-GPUSelectionMenu; Process-Textures "512" }
        "2" { Show-GPUSelectionMenu; Process-Textures "1024" }
        "3" { Show-GPUSelectionMenu; Process-Textures "2048" }
        "4" { Write-Host "Exiting..."; return }
        default { Write-Host "Invalid option, please try again"; Show-MainMenu }
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
Set-Location -Path $Global:RootDirectory
Show-MainMenu
