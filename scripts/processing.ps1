# Script: scrips\processing.ps1

# Process Textures
function Process-Textures {
    param (
        [string]$resolution
    )
    # Resolution-based processing
    $targetResolution = [int]$resolution
    Process-LooseTextures -targetResolution $targetResolution
    Process-BA2Textures -targetResolution $targetResolution
}

# Loose Texture Processing
function Process-LooseTextures {
    param (
        [int]$targetResolution
    )
    Copy-Item -Path $Global:TexturesDirectory -Destination $Global:CacheDirectory -Recurse
    $textures = Get-ChildItem -Path $Global:CacheDirectory -Filter $Global:DdsFilePattern -Recurse
    foreach ($texture in $textures) {
        if (Check-TextureSize -texturePath $texture.FullName -targetResolution $targetResolution) {
            $format = Determine-Format $texture.FullName
            $imageName = [System.IO.Path]::GetFileName($texture.FullName)
            $imageResolution = Get-TextureResolution -texturePath $texture.FullName
            Convert-Texture -texturePath $texture.FullName -format $format -imageName $imageName -imageResolution $imageResolution
        }
    }
    Move-Item -Path $Global:CacheDirectory -Destination $Global:TexturesDirectory -Force
    Write-Host "Loose Textures Processed"
}


# BA2 Texture Processing
function Process-BA2Textures {
    $ba2Files = Get-ChildItem -Path $Global:DataDirectory -Filter "*Textures.ba2"
    foreach ($ba2File in $ba2Files) {
        $extractedPath = Join-Path $Global:CacheDirectory (Split-Path $ba2File.Name -Leaf)
        try {
            # Extract all files from BA2 file
            & $Global:SevenZipExecutable e $ba2File.FullName -o$extractedPath -y
            
            # Process only textures
            Process-LooseTextures -TextureDirectory (Join-Path $extractedPath "textures")
            
            # Delete non-texture files from cache
            Get-ChildItem -Path $extractedPath -Exclude "textures" -Recurse | Remove-Item -Force

            # Update original BA2 file with processed textures
            & $Global:SevenZipExecutable u $ba2File.FullName $extractedPath\* -y
        } catch {
            Write-Error "BA2 Processing Failed: $_"
        }
    }
}

# Texture Converter
function Convert-Texture {
    param (
        [string]$texturePath,
        [string]$format,
        [string]$imageName,
        [string]$imageResolution
    )
    try {
        & $Global:TexConvExecutable -f $format -fl 11.0 -gpu $Global:SelectedGPU -y $texturePath
        Write-Host "Converting $imageName from $imageResolution"
    } catch {
        Write-Error "Conversion Failed for $imageName"
    }
}

# BA2 Repackaging
function Compress-BA2 {
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

# Texture Size Check
function Check-TextureSize {
    param (
        [string]$texturePath,
        [int]$targetResolution
    )
    try {
        $output = & $Global:TexDiagExecutable info -nologo $texturePath
        $width = ($output | Where-Object { $_ -match "width = (\d+)" }) -replace "width = ", ""
        $height = ($output | Where-Object { $_ -match "height = (\d+)" }) -replace "height = ", ""

        return ([int]$width -gt $targetResolution -or [int]$height -gt $targetResolution)
    } catch {
        Write-Error "Size Check Failed: $_"
        return $false
    }
}

# Format Determination
function Determine-Format {
    param (
        [string]$texturePath
    )
    try {
        $output = & $Global:TexDiagExecutable info -nologo $texturePath
        $formatLine = $output | Where-Object { $_ -match "format = (\w+)" }
        if ($formatLine) {
            $format = $formatLine -replace "format = ", ""
            # Check if the format supports transparency
            $hasTransparency = $format -match "BC3|BC7"
            return $hasTransparency ? "BC7_UNORM" : "BC1_UNORM"
        } else {
            throw "Unable to determine texture format."
        }
    } catch {
        Write-Error "Format Determination Failed: $_"
        return $null
    }
}

# Get Texture Resolution
function Get-TextureResolution {
    param (
        [string]$texturePath
    )
    $output = & $Global:TexDiagExecutable info -nologo $texturePath
    $width = ($output | Where-Object { $_ -match "width = (\d+)" }) -replace "width = ", ""
    $height = ($output | Where-Object { $_ -match "height = (\d+)" }) -replace "height = ", ""
    return "$width x $height"
}
