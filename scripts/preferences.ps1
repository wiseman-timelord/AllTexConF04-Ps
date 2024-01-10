# Script: preferences.ps1

# Function Update Datafolderlocation
function Update-DataFolderLocation {
    $newDataFolder = Read-Host "Enter New Location, or N for no update"
    if ($newDataFolder -ne 'N') {
        $Global:DataDirectory = $newDataFolder
        $Global:Config.DataFolderLocation = $newDataFolder

# Variables
		$Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
    }
}

# Function Toggle CharacterTextures
function Toggle-CharacterTextures {
    $Global:ProcessCharacterTextures = -not $Global:ProcessCharacterTextures
    $Global:Config.ProcessCharacterTextures = $Global:ProcessCharacterTextures
    $Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
}

# Function Toggle Imageresolution
function Toggle-ImageResolution {
    $currentIndex = $Global:AvailableResolutions.IndexOf($Global:TargetResolution)
    $nextIndex = ($currentIndex + 1) % $Global:AvailableResolutions.Count
    $Global:TargetResolution = $Global:AvailableResolutions[$nextIndex]
	$Global:Config.TargetResolution = $Global:TargetResolution
    $Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
}

# Function Toggle Gpuselection
function Toggle-GPUSelection {
    $currentSelection = $Global:SelectedGPU
    $nextSelection = ($currentSelection + 1) % $Global:GpuList.Count
    $Global:SelectedGPU = $nextSelection
	$Global:Config.GpuCardSelectionNumber = $Global:SelectedGPU
    $Global:Config | Export-PowerShellDataFile -Path ".\scripts\configuration.psd1"
}

# Function Get Gpulist
function Get-GPUList {
    $texconvOutput = & $Global:TexConvExecutable
    if (-not $texconvOutput) {
        Write-Error "Failed to execute TexConvExecutable or no output captured."
        return @()
    }
    $lines = $texconvOutput -split "`r`n"
    $adapterLineMatch = $lines | Select-String "^\s*<adapter>:" | Select-Object -First 1
    if (-not $adapterLineMatch) {
        Write-Error "No '<adapter>:' line found in output."
        return @()
    }
    $adapterLineIndex = $adapterLineMatch.LineNumber - 1
    $gpuList = @()
    for ($i = $adapterLineIndex + 1; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "^\s*(\d+): VID:\w+, PID:\w+ - (.+)") {
            $gpuNumber = [int]($matches[1]) + 1
            $gpuInfo = $matches[2].Trim()
            $formattedLine = "{0}: {1}" -f $gpuNumber, $gpuInfo
            $gpuList += $formattedLine
        } elseif ($line.Trim() -eq "") {
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