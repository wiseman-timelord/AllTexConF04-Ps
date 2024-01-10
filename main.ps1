# Script: main.ps1

# Variables
$Global:Config = Import-PowerShellDataFile -Path ".\scripts\configuration.psd1"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Global:ToolsDirectory = $scriptPath
$Global:BinDirectory = Join-Path $scriptPath "binaries"
$Global:TexConvExecutable = Join-Path $Global:BinDirectory "texconv.exe"
$Global:TexDiagExecutable = Join-Path $Global:BinDirectory "texdiag.exe"
$Global:CacheDirectory = Join-Path $scriptPath "cache"
$Global:DataDirectory = $Global:Config.DataFolderLocation
$Global:SelectedGPU = $Global:Config.GpuCardSelectionNumber
$Global:ProcessCharacterTextures = $Global:Config.ProcessCharacterTextures
$Global:AvailableResolutions = @(512, 1024, 2048)
$Global:TargetResolution = 1024  
$Global:SelectedGPU = 0  
$Global:ProcessingStartTime = $null
$Global:ProcessingEndTime = $null
$Global:FilesProcessed = 0
$Global:FilesPassed = 0
$Global:PreviousDataSize = 0
$Global:ResultingDataSize = 0

# Imports
. ".\scripts\processing.ps1"
. ".\scripts\preferences.ps1"
. ".\scripts\artwork.ps1"

# Function Show Configurationmenu
function Show-ConfigurationMenu {
    do {
        Clear-Host
		Show-AsciiArt
		Show-Title
        Write-Host "             ---( Pre-Processing Configuration )---`n"
        Write-Host "                    1. Data Folder Location"
        Write-Host "     $($Global:DataDirectory)`n"
        Write-Host "                    2. Max Image Resolution"
        Write-Host "                           RATIOx$($Global:TargetResolution)`n"
        Write-Host "                     3. Graphics Processor"
        if ($Global:GpuList.Count -gt 0) {
            $currentGpuDisplay = $Global:GpuList[$Global:SelectedGPU].Split(':')[1].Trim()
        } else {
            $currentGpuDisplay = "No GPU Found"
        }
        Write-Host "                  $currentGpuDisplay`n"
        Write-Host "                    4. Character Textures"
$charTextureStatus = if ($Global:ProcessCharacterTextures) { "Process" } else { "Ignore" }
Write-Host "                            $charTextureStatus`n"
		Write-Host "                      B. Begin Processing"
		Write-Host "                   (Ensure Correct Settings!!)`n"
		Write-Host "                        X. Exit Program`n"
        Show-Divider
        $choice = Read-Host "Select, Menu Options=1-3, Begin Resizing=B, Exit Program=X"
        switch ($choice) {
            "1" { Update-DataFolderLocation }
            "2" { Toggle-ImageResolution }
            "3" { Toggle-GPUSelection }
			"4" { Toggle-CharacterTextures }
            "B" { InitiateTextureProcessing $Global:TargetResolution; break }
            "X" { Write-Host "Exiting..."; return }
            default { Write-Host "Invalid option, please try again" }
        }
    } while ($true)
}

# Function Displaysummaryscreen
function DisplaySummaryScreen {
    $processingTime = $Global:ProcessingEndTime - $Global:ProcessingStartTime
    $processingTimeFormatted = "{0:HH:mm}" -f [datetime]$processingTime.TotalSeconds
    $dataSaved = $Global:PreviousDataSize - $Global:ResultingDataSize
    $percentReduction = [math]::Round(($dataSaved / $Global:PreviousDataSize) * 100, 2)
    $score = CalculateScore -texturesProcessed $Global:FilesProcessed -processingTime $processingTime
    $verdict = "Average Score!"
    if ($score -gt $Global:Config.UserCurrentHighScore) {
        $Global:Config.UserCurrentHighScore = $score
        $verdict = "New HighScore!"
    }
    elseif ($score -lt $Global:Config.UserCurrentLowScore -or $Global:Config.UserCurrentLowScore -eq 0) {
        $Global:Config.UserCurrentLowScore = $score
        $verdict = "New LowScore!"
    }
	Clear-Host
	Show-AsciiArt
    Show-Title
    Write-Host "-----------------------( Final Summary )-----------------------"
    Write-Host "Processing Stats:"
    Write-Host "Start: $($Global:ProcessingStartTime.ToString('HH:mm')), Duration: $processingTimeFormatted"
    Write-Host "Processed: $($Global:FilesProcessed), Passed: $($Global:FilesPassed)"
    Write-Host "Saved: $($dataSaved) MB, Reduction: $percentReduction%"
    Write-Host "`nResulting Scores:"
    Write-Host "Current: $score, Previous: $($Global:Config.UserPreviousScore)"
    Write-Host "Highest: $($Global:Config.UserCurrentHighScore), Lowest: $($Global:Config.UserCurrentLowScore)"
    Write-Host "`nVerdict:"
    Write-Host "$verdict"
    Show-Divider
    Write-Host "`nSelect, Exit Program=X, Error Log=E"
    $choice = Read-Host "Select"
    switch ($choice) {
        "X" { Write-Host "Exiting..."; return }
        "E" {
            if (Test-Path ".\Errors-Crash.Log") {
                Get-Content ".\Errors-Crash.Log" | Out-Host
            } else {
                Write-Host "Error log file does not exist."
            }
        }
        default { Write-Host "Invalid option, please try again"; DisplaySummaryScreen }
    }
}

# Entry Point
Set-Location -Path $scriptPath
$Global:GpuList = Get-GPUList
Show-ConfigurationMenu
