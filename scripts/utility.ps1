# Script: utility.ps1

# Centralize Menu Text
function Get-CenteredText {
    param (
        [string]$text,
        [int]$totalWidth
    )
    $paddingSize = [math]::Max(0, ($totalWidth - $text.Length) / 2)
    return (' ' * $paddingSize) + $text
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

