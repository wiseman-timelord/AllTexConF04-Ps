# Script: processing.ps1

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
    ProcessIndividualTextures -targetResolution $targetResolution
    ProcessCompressedTextureFiles -targetResolution $targetResolution
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
        Write-Host "$($texture.Name): Analyzing Image Size."
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
        $extractedPath = Join-Path $Global:CacheDirectory (Split-Path $ba2File.Name -Leaf)
        try {
            & $Global:SevenZipExecutable e $ba2File.FullName -o$extractedPath -y
            ProcessIndividualTextures -targetResolution $targetResolution
            Get-ChildItem -Path $extractedPath -Exclude "textures" -Recurse | Remove-Item -Force
            & $Global:SevenZipExecutable u $ba2File.FullName $extractedPath\* -y
            Write-Host "$($ba2File.Name): Contents RePackaged."
        } catch {
            Write-Error "BA2 Processing Failed: $_"
        }
    }
}

# Function Adjusttexturesize
function AdjustTextureSize {
    param (
        [string]$texturePath,
        [int]$targetResolution,
        [string]$format
    )
    try {
        & $Global:TexConvExecutable -f $format -fl 11.0 -gpu $Global:SelectedGPU -y -w $targetResolution -h $targetResolution $texturePath
        Write-Host "$(Split-Path $texturePath -Leaf): Resized $targetResolution x $($imageInfo.Height)-$format."
        $Global:FilesProcessed += 1
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
