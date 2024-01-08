# Script: scrips\processing.ps1

function InitiateTextureProcessing {
    param (
        [string]$resolution
    )
    $Global:ProcessingStartTime = Get-Date
    $Global:FilesProcessed = 0

    $targetResolution = [int]$resolution
    ProcessIndividualTextures -targetResolution $targetResolution
    ProcessCompressedTextureFiles -targetResolution $targetResolution

    $Global:ProcessingEndTime = Get-Date

    # Invoke the summary screen
    DisplaySummaryScreen
}

# Texture Info Retrieval
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

# Loose Texture Processing
function ProcessIndividualTextures {
    param (
        [int]$targetResolution
    )
    $texturesPath = Join-Path $Global:DataDirectory "Textures"
    # Hardcoding DdsFilePattern as "*.dds"
    $textures = Get-ChildItem -Path $texturesPath -Filter "*.dds" -Recurse
    foreach ($texture in $textures) {
        $imageInfo = RetrieveTextureDetails -texturePath $texture.FullName
        if ($imageInfo.Width -gt $targetResolution) {
            AdjustTextureSize -texturePath $texture.FullName -targetResolution $targetResolution -format $imageInfo.Format
        }
    }
    Write-Host "Loose Textures Processed"
}

# BA2 Texture Processing
function ProcessCompressedTextureFiles {
    param (
        [int]$targetResolution
    )
    # Hardcoding Ba2FilePattern as "*textures.ba2"
    $ba2Files = Get-ChildItem -Path $Global:DataDirectory -Filter "*textures.ba2"
    foreach ($ba2File in $ba2Files) {
        $extractedPath = Join-Path $Global:CacheDirectory (Split-Path $ba2File.Name -Leaf)
        try {
            & $Global:SevenZipExecutable e $ba2File.FullName -o$extractedPath -y
            ProcessIndividualTextures -targetResolution $targetResolution
            Get-ChildItem -Path $extractedPath -Exclude "textures" -Recurse | Remove-Item -Force
            & $Global:SevenZipExecutable u $ba2File.FullName $extractedPath\* -y
        } catch {
            Write-Error "BA2 Processing Failed: $_"
        }
    }
}

# Texture Resizing
function AdjustTextureSize {
    param (
        [string]$texturePath,
        [int]$targetResolution,
        [string]$format
    )
    try {
        & $Global:TexConvExecutable -f $format -fl 11.0 -gpu $Global:SelectedGPU -y -w $targetResolution -h $targetResolution $texturePath
        Write-Host "Resized $texturePath to $targetResolution x $targetResolution"
    } catch {
        Write-Error "Resizing Failed for $texturePath"
    }
}

# BA2 Repackaging
function RepackageTexturesIntoBA2 {
    param (
        [string]$sourceDirectory,
        [string]$ba2FilePath
    )
    try {
        # Compress files back into .ba2 format
        & $Global:SevenZipExecutable a $ba2FilePath $sourceDirectory\* -y
        Write-Host "BA2 Repackaged"
    } catch {
        Write-Error "BA2 Compression Failed"
    }
}
