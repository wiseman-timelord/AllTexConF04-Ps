# Script: preferences.ps1

# Function Show Configurationmenu
function Show-ConfigurationMenu {
    do {
        Clear-Host
        Show-AsciiArt
        Show-Title
        Write-Host "`n                    1. Data Folder Location"
        Write-Host "  $($Global:DataDirectory)`n"
        Write-Host "                  2. Textures\Actors\Character"
        $charTextureStatus = if ($Global:ProcessCharacterTextures) { "Process" } else { "Ignore" }
        Write-Host "                            $charTextureStatus`n"
        Write-Host "                    3. Max Image Resolution"
        Write-Host "                          RATIOx$($Global:TargetResolution)`n"
        Write-Host "                     4. Graphics Processor"
        if ($Global:GpuList.Count -gt 0) {
            $currentGpuDisplay = $Global:GpuList[$Global:SelectedGPU].Split(':')[1].Trim()
        } else {
            $currentGpuDisplay = "No GPU Found"
        }
        Write-Host "                  $currentGpuDisplay`n"
        $archiveMultiThreadStatus = if ($Global:ArchiveMultithreading) { "Multi-Thread" } else { "Single-Thread" }
        Write-Host "                   5. Multi-Thread Archiving"
        Write-Host "                         $archiveMultiThreadStatus`n`n`n"
        Show-Divider
        $choice = Read-Host "Select, Menu Options=1-5, Begin Resizing=B, Exit Program=X"
        switch ($choice) {
            "1" { Update-DataFolderLocation }
            "2" { Toggle-CharacterTextures }
            "3" { Toggle-ImageResolution }
            "4" { Toggle-GPUSelection }
            "5" { Toggle-ArchiveMultithreading }
            "B" { InitiateTextureProcessing $Global:TargetResolution; break }
            "X" { Write-Host "Exiting..."; Clear-Host; return }
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
    Write-Host "             ---( Pre-Processing Configuration )---`n"
    Write-Host "                     ---( Final Summary )---"
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

# Function Update Datafolderlocation
function Update-DataFolderLocation {
    $newDataFolder = Read-Host "Enter New Location, or N for no update"
    if ($newDataFolder -ne 'N') {
        $Global:DataDirectory = $newDataFolder
        $Global:Config.DataFolderLocation = $newDataFolder
		Export-PowerShellData1 -Data $Global:Config -Name -Path ".\scripts\settings.psd1"
    }
}

function Toggle-CharacterTextures {
    $Global:ProcessCharacterTextures = -not $Global:ProcessCharacterTextures
    $Global:Config.ProcessCharacterTextures = $Global:ProcessCharacterTextures
    Export-PowerShellData1 -Data $Global:Config -Name -Path ".\scripts\settings.psd1"
}

function Toggle-ArchiveMultithreading {
    $Global:ArchiveMultithreading = -not $Global:ArchiveMultithreading
    $Global:Config.ArchiveMultithreading = $Global:ArchiveMultithreading
    Export-PowerShellData1 -Data $Global:Config -Name -Path ".\scripts\settings.psd1"
}

# Function Toggle CharacterTextures
function Toggle-CharacterTextures {
    $Global:ProcessCharacterTextures = -not $Global:ProcessCharacterTextures
    $Global:Config.ProcessCharacterTextures = $Global:ProcessCharacterTextures
    Export-PowerShellData1 -Data $Global:Config -Name -Path ".\scripts\settings.psd1"
}

# Function Toggle Imageresolution
function Toggle-ImageResolution {
    $currentIndex = $Global:AvailableResolutions.IndexOf($Global:TargetResolution)
    $nextIndex = ($currentIndex + 1) % $Global:AvailableResolutions.Count
    $Global:TargetResolution = $Global:AvailableResolutions[$nextIndex]
	$Global:Config.TargetResolution = $Global:TargetResolution
    Export-PowerShellData1 -Data $Global:Config -Name -Path ".\scripts\settings.psd1"
}

# Function Toggle Gpuselection
function Toggle-GPUSelection {
    $currentSelection = $Global:SelectedGPU
    $nextSelection = ($currentSelection + 1) % $Global:GpuList.Count
    $Global:SelectedGPU = $nextSelection
	$Global:Config.GpuCardSelectionNumber = $Global:SelectedGPU
    Export-PowerShellData1 -Data $Global:Config -Name -Path ".\scripts\settings.psd1"
}
