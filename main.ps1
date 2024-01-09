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
$Global:TargetResolution = 1024  
$Global:SelectedGPU = 0  
$Global:ProcessingStartTime = $null
$Global:ProcessingEndTime = $null
$Global:FilesProcessed = 0
$Global:FilesPassed = 0
$Global:PreviousDataSize = 0
$Global:ResultingDataSize = 0
. ".\scripts\processing.ps1"

# Function Show Title
function Show-Title {
    Clear-Host
	Write-Host "`n======================( AllTexConFO4-Ps )======================"
}

# Function Divider
function Show-Divider {
	Write-Host "---------------------------------------------------------------"
}

# Function Show Mainmenu
function Show-MainMenu {
    Show-Title
    Write-Host "-------------------------( Main Menu )-------------------------`n`n`n`n`n`n`n`n"
    Write-Host "                 1. Set Data Folder Location,`n"
    Write-Host "                 2. Set Max Image Resolution,`n"
    Write-Host "                 3. Set GPU Processor To Use,`n"
    Write-Host "                 B. Begin Processing Textures,`n"
    Write-Host "                       X. Exit Program.`n`n`n`n`n`n`n"
	Show-Divider
    $choice = Read-Host "Select, Settings=1-3, Begin=B, Exit=X"
    switch ($choice) {
        "1" { Show-DataFolderMenu }
        "2" { Show-ResolutionMenu }
        "3" { Show-GPUSelectionMenu }
        "B" { InitiateTextureProcessing $Global:TargetResolution }
        "X" { Write-Host "Exiting..."; return }
        default { Write-Host "Invalid option, please try again"; Show-MainMenu }
    }
}

# Function Show Datafoldermenu
function Show-DataFolderMenu {
    Show-Title
    $dataFolderDisplay = if ($Global:DataDirectory.Length -le 58) { $Global:DataDirectory.PadLeft(($Global:DataDirectory.Length + 58) / 2) } else { $Global:DataDirectory }
    Write-Host "-----------------------( Folders Menu )------------------------`n`n`n`n`n`n`n`n`n"
    Write-Host "                    Fallout 4\Data Location:`n    $dataFolderDisplay`n"
    Write-Host "                     1. Enter New Location`n"
    Write-Host "                     M. Return To Main Menu`n`n`n`n`n`n`n`n`n"
    Show-Divider
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

# Function Show Resolutionmenu
function Show-ResolutionMenu {
    Show-Title
    Write-Host "------------------------( Format Menu )------------------------`n`n`n`n`n`n`n"
    Write-Host "                      Current Resolution:"
	Write-Host "                             *x$($Global:TargetResolution)`n"
    Write-Host "                   1. Set Max Res To *x512`n"
    Write-Host "                   2. Set Max Res To *x1024`n"
    Write-Host "                   3. Set Max Res To *x2048`n"
    Write-Host "                    M. Return To Main Menu`n`n`n`n`n`n`n"
    Show-Divider
	$choice = Read-Host "`nSelect, Options 1-3, Main Menu=M"
    switch ($choice) {
        "1" { $Global:TargetResolution = 512; Show-ResolutionMenu }
        "2" { $Global:TargetResolution = 1024; Show-ResolutionMenu }
        "3" { $Global:TargetResolution = 2048; Show-ResolutionMenu }
        "M" { Show-MainMenu }
        default { Write-Host "Invalid option, please try again"; Show-ResolutionMenu }
    }
}

# Function Get Gpulist
function Get-GPUList {
    # Execute TexConvExecutable
    $texconvOutput = & $Global:TexConvExecutable
    if (-not $texconvOutput) {
        Write-Error "Failed to execute TexConvExecutable or no output captured."
        return @()
    }

    # Convert output to an array of lines
    $lines = $texconvOutput -split "`r`n"

    # Find the index of the line containing '<adapter>:' with indentation
    $adapterLineMatch = $lines | Select-String "^\s*<adapter>:" | Select-Object -First 1
    if (-not $adapterLineMatch) {
        Write-Error "No '<adapter>:' line found in output."
        return @()
    }
    $adapterLineIndex = $adapterLineMatch.LineNumber - 1

    # Extract GPU information lines and format them
    $gpuList = @()
    for ($i = $adapterLineIndex + 1; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "^\s*(\d+): VID:\w+, PID:\w+ - (.+)") {
            $gpuNumber = [int]($matches[1]) + 1
            $gpuInfo = $matches[2].Trim()
            $formattedLine = "{0}: {1}" -f $gpuNumber, $gpuInfo
            $gpuList += $formattedLine
        } elseif ($line.Trim() -eq "") {
            # Break the loop if a blank line is encountered
            break
        }
    }

    return $gpuList
}

# Function Show Gpuselectionmenu
function Show-GPUSelectionMenu {
    Show-Title
    Write-Host "--------------------------( GPU Menu )-------------------------`n`n`n`n`n`n"
    
    $gpuList = Get-GPUList

    # Calculate spacer lines before and after GPU list
    $spacerLinesBefore = [math]::Max(0, 2 - $gpuList.Count)
    $spacerLinesAfter = 4 - $spacerLinesBefore - $gpuList.Count

    # Print spacer lines before GPU list
    Write-Host ("`n" * $spacerLinesBefore)

    # Display current GPU
    $currentGpu = if ($Global:SelectedGPU -ge 0 -and $Global:SelectedGPU -lt $gpuList.Count) {
        $gpuList[$Global:SelectedGPU].Split(':')[1].Trim()
    } else {
        "Not Selected"
    }
    Write-Host "                          Current GPU:"
    Write-Host "                   $currentGpu`n"

    # Display list of GPUs
    foreach ($gpu in $gpuList) {
        Write-Host "                $gpu`n"
    }
    Write-Host "                    M. Return To Main Menu`n`n`n`n`n"

    # Print spacer lines after GPU list
    Write-Host ("`n" * $spacerLinesAfter)

    Show-Divider
    $choice = Read-Host "Select, GPU Choice=1-$($gpuList.Count), Main Menu=M"

    # Process selection
    if ($choice -eq 'M') {
        Show-MainMenu
    } elseif ($choice -in (1..$gpuList.Count)) {
        $Global:SelectedGPU = $choice - 1 # Adjust to zero-based index
        # Update configuration file
        $Global:Config.GpuCardSelectionNumber = $Global:SelectedGPU
        $Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
        Show-MainMenu
    } else {
        Write-Host "Invalid option, please try again"
        Show-GPUSelectionMenu
    }
}




# Function Calculatescore
function CalculateScore {
    param (
        [int]$texturesProcessed,
        [TimeSpan]$processingTime
    )
    if ($processingTime.TotalSeconds -eq 0) { return 0 }
    return [math]::Round(($texturesProcessed / $processingTime.TotalSeconds) * 10, 2)
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
    PauseMenu
}

# Function Pausemenu
function PauseMenu {
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
        default { Write-Host "Invalid option, please try again"; PauseMenu }
    }
}

# Main Entry
Set-Location -Path $scriptPath
Show-MainMenu
