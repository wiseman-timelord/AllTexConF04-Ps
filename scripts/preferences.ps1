# Script: scripts\preferences.ps1

function Update-DataFolderLocation {
    $newDataFolder = Read-Host "Enter New Location, or N for no update"
    if ($newDataFolder -ne 'N') {
        $Global:DataDirectory = $newDataFolder
        $Global:Config.DataFolderLocation = $newDataFolder
		$Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
    }
}

function Toggle-ImageResolution {
    $currentIndex = $Global:AvailableResolutions.IndexOf($Global:TargetResolution)
    $nextIndex = ($currentIndex + 1) % $Global:AvailableResolutions.Count
    $Global:TargetResolution = $Global:AvailableResolutions[$nextIndex]
	$Global:Config.TargetResolution = $Global:TargetResolution
    $Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
}


function Toggle-GPUSelection {
    $currentSelection = $Global:SelectedGPU
    $nextSelection = ($currentSelection + 1) % $Global:GpuList.Count
    $Global:SelectedGPU = $nextSelection
	$Global:Config.GpuCardSelectionNumber = $Global:SelectedGPU
    $Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
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

# Function Calculatescore
function CalculateScore {
    param (
        [int]$texturesProcessed,
        [TimeSpan]$processingTime
    )
    if ($processingTime.TotalSeconds -eq 0) { return 0 }
    return [math]::Round(($texturesProcessed / $processingTime.TotalSeconds) * 10, 2)
}