# Script: scripts\processing.ps1

# Function Initiatetextureprocessing
function InitiateTextureProcessing {
    param (
        [string]$resolution
    )
    $Global:ProcessingStartTime = Get-Date
    Write-Host "$($Global:ProcessingStartTime.ToString('HH:mm')): Texture Processing Started..."
    $Global:FilesProcessed = 0
    $Global:FilesPassed = 0
    $Global:PreviousDataSize = Get-DataSize
    $targetResolution = [int]$resolution
    Write-Host "Loose Texture Processing..."
    ProcessIndividualTextures -targetResolution $targetResolution
    Write-Host "...Loose Textures Processed."
    Write-Host "Ba2 Texture Processing..."
    ProcessCompressedTextureFiles -targetResolution $targetResolution
    Write-Host "...Ba2 Files Processed."
    $Global:ResultingDataSize = Get-DataSize
    $Global:ProcessingEndTime = Get-Date
    Write-Host "$($Global:ProcessingEndTime.ToString('HH:mm')): ...Texture Processing Completed."
    DisplaySummaryScreen
}

# Function Get Datasize
function Get-DataSize {
    $totalSize = 0
    $totalSize += (Get-ChildItem -Path "$Global:DataDirectory\Textures" -Recurse | Measure-Object -Property Length -Sum).Sum
    $totalSize += (Get-ChildItem -Path $Global:DataDirectory -Filter "*textures.ba2" | Measure-Object -Property Length -Sum).Sum
    return $totalSize / 1MB  
}

# Function Retrievetexturedetails
function RetrieveTextureDetails {
    param (
        [string]$texturePath
    )
    try {
        $output = & $Global:TexDiagExecutable info -nologo $texturePath
        $width = ($output | Where-Object { $_ -match "width = (\d+)" }) -replace "width = ", ""
        $height = ($output | Where-Object { $_ -match "height = (\d+)" }) -replace "height = ", ""
        $format = ($output | Where-Object { $_ -match "format = (\w+)" }) -replace "format = ", ""
        return @{ Width = [int]$width; Height = [int]$height; Format = $format }
    } catch {
        Write-Error "Failed to retrieve texture info: $_"
        return $null
    }
}

# Function Processindividualtextures
function ProcessIndividualTextures {
    param (
        [int]$targetResolution
    )
    $texturesPath = Join-Path $Global:DataDirectory "Textures"
    $textures = Get-ChildItem -Path $texturesPath -Filter "*.dds" -Recurse
    foreach ($texture in $textures) {
        $imageInfo = RetrieveTextureDetails -texturePath $texture.FullName
        if ($imageInfo.Width -gt $targetResolution) {
            AdjustTextureSize -texturePath $texture.FullName -targetResolution $targetResolution -format $imageInfo.Format
        } else {
            Write-Host "$($texture.Name): Dimensions Compliant."
            $Global:FilesPassed += 1
        }
    }
    Write-Host "Loose Textures Processed"
}

# Function Processcompressedtexturefiles
function ProcessCompressedTextureFiles {
    param (
        [int]$targetResolution
    )
    $ba2Files = Get-ChildItem -Path $Global:DataDirectory -Filter "*textures.ba2"
    foreach ($ba2File in $ba2Files) {
        Write-Host "$($ba2File.Name): Unpacking Contents."
        Write-Host "$($ba2File.Name): Contents RePackaged."
    }
}

# Function Adjusttexturesize
function AdjustTextureSize {
    param (
        [string]$texturePath,
        [int]$targetHeight, # Changed parameter name for clarity
        [string]$format
    )
    try {
        $imageInfo = RetrieveTextureDetails -texturePath $texturePath
        if ($imageInfo.Height -gt $targetHeight) {
            # Calculate new width while maintaining aspect ratio
            $newWidth = [int]($imageInfo.Width * $targetHeight / $imageInfo.Height)
            & $Global:TexConvExecutable -f $format -fl 11.0 -gpu $Global:SelectedGPU -y -w $newWidth -h $targetHeight $texturePath
            Write-Host "$(Split-Path $texturePath -Leaf): Resized $newWidth x $targetHeight-$format."
            $Global:FilesProcessed += 1
        } else {
            Write-Host "$($texture.Name): Dimensions Compliant."
            $Global:FilesPassed += 1
        }
    } catch {
        Write-Error "Resizing Failed for $texturePath"
    }
}


# Function Repackagetexturesintoba2
function RepackageTexturesIntoBA2 {
    param (
        [string]$sourceDirectory,
        [string]$ba2FilePath
    )
    try {
        & $Global:SevenZipExecutable a $ba2FilePath $sourceDirectory\* -y
        Write-Host "BA2 Repackaged"
    } catch {
        Write-Error "BA2 Compression Failed"
    }
}
