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
    Write-Host "Loose Texture Processing..."
    ProcessIndividualTextures -targetResolution $targetResolution
    Write-Host "...Loose Textures Processed."
    Write-Host "Archive Texture Processing..."
    ProcessCompressedTextureFiles -targetResolution $targetResolution
    Write-Host "...Archive Files Processed."
    $Global:ResultingDataSize = Get-DataSize
    $Global:ProcessingEndTime = Get-Date
    Write-Host "$($Global:ProcessingEndTime.ToString('HH:mm')): ...Texture Processing Completed."
    DisplaySummaryScreen
}

# Function Get Datasize
function Get-DataSize {
    $totalSize = 0
    $totalSize += (Get-ChildItem -Path "$Global:DataDirectory" -Recurse | Measure-Object -Property Length -Sum).Sum
    $totalSize += (Get-ChildItem -Path $Global:DataDirectory -Filter "*.ba2" | Measure-Object -Property Length -Sum).Sum
	$totalSize += (Get-ChildItem -Path $Global:DataDirectory -Filter "*.bsa" | Measure-Object -Property Length -Sum).Sum
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
        # Skip character textures if processing is disabled
        if (-not $Global:ProcessCharacterTextures -and $texture.FullName -like "*\Actors\Character\*") {
            Write-Host "$($texture.Name): Character Texture Skipped."
            Continue
        }

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

# Function Adjusttexturesize
function AdjustTextureSize {
    param (
        [string]$texturePath,
        [int]$targetHeight, 
        [string]$format
    )
    try {
        $imageInfo = RetrieveTextureDetails -texturePath $texturePath
        if ($imageInfo.Height -gt $targetHeight) {
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

function Get-ArchiveFormat {
    param ([string]$archivePath)

    $output = & $Global:BSArch64Executable $archivePath
    if ($output -match "Format:\s*(.+)\s") {
        switch -Regex ($Matches[1]) {
            "Morrowind" { return "-tes3" }
            "Oblivion" { return "-tes4" }
            "Fallout 3" { return "-fo3" }
            "Fallout: New Vegas" { return "-fnv" }
            "Skyrim LE" { return "-tes5" }
            "Skyrim Special Edition" { return "-sse" }
            "Fallout 4" { return "-fo4" }
            "Fallout 4 DDS" { return "-fo4dds" }
            "Starfield" { return "-sf1" }
            "Starfield DDS" { return "-sf1dds" }
            default { throw "Unknown archive format: $($Matches[1])" }
        }
    } else {
        throw "Failed to determine archive format for $archivePath"
    }
}

# Function Repackagetexturesintoba2
function RepackageTexturesIntoBA2 {
    param (
        [string]$sourceDirectory,
        [string]$ba2FilePath,
        [string]$formatFlag
    )
    try {
        $mtOption = if ($Global:ArchiveMultithreading) { "-mt" } else { "" }
        Write-Host "Repackaging into $ba2FilePath using format $formatFlag $mtOption."
        & $Global:BSArch64Executable pack $sourceDirectory $ba2FilePath $formatFlag $mtOption
        Write-Host "...Archive Repackaged"
    } catch {
        Write-Error "Archive Compression Failed: $_"
    }
}

# Function Processcompressedtexturefiles
function ProcessCompressedTextureFiles {
    param (
        [int]$targetResolution
    )
    $compressedFiles = Get-ChildItem -Path $Global:DataDirectory -Filter "*.ba2", "*.bsa"
    foreach ($compressedFile in $compressedFiles) {
        $formatFlag = Get-ArchiveFormat -archivePath $compressedFile.FullName
        $unpackFolder = Join-Path $Global:CacheDirectory $compressedFile.BaseName
        $mtOption = if ($Global:ArchiveMultithreading) { "-mt" } else { "" }

        Write-Host "$($compressedFile.Name): Unpacking Contents."
        & $Global:BSArch64Executable unpack $compressedFile.FullName $unpackFolder -q $mtOption

        # Process the textures in $unpackFolder as per your existing logic

        Write-Host "$($compressedFile.Name): Contents RePackaged."
        RepackageTexturesIntoBA2 -sourceDirectory $unpackFolder -ba2FilePath $compressedFile.FullName -formatFlag $formatFlag
    }
}

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
    Write-Host "Archive Texture Processing..."
    ProcessCompressedTextureFiles -targetResolution $targetResolution
    Write-Host "...Archive Files Processed."
    $Global:ResultingDataSize = Get-DataSize
    $Global:ProcessingEndTime = Get-Date
    Write-Host "$($Global:ProcessingEndTime.ToString('HH:mm')): ...Texture Processing Completed."
    DisplaySummaryScreen
}