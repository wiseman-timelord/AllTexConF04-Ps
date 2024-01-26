# Script: impexppsd1.ps1

# Title: Wiseman-Timelords Import/Export Script 
# Url: https://github.com/wiseman-timelord/ImpExpPsd1-Ps
#
# Import, usage & syntax:
# $ConfigData = Import-PowerShellData1 -Path "C:\path\to\config.psd1"
# $Setting1Value = $ConfigData.Setting1
#
# Export, syntax and usage:
#
# Using global with hashtable import...
# $Global:Config = Import-PowerShellData1 -Path "C:\path\to\your\file.psd1"
# Export-PowerShellData1 -Data $Global:Config -Path "C:\path\to\your\file.psd1"
#
# Using hashtable...
# $data = @{
#     Setting1 = 'Value1'
#     Setting2 = 'Value2'
# }
# Export-PowerShellData1 -Data $data -Path 'C:\path\to\your\file.psd1'
#
# Options...
# -Name (comment "# Script: file.psd1", extracted from -Path detail).

# Function Import Psd1
function Import-PowerShellData1 {
    param (
        [string]$Path
    )
    $content = Get-Content -Path $Path -Raw
    $content = $content -replace '^(#.*[\r\n]*)+', '' # Remove lines starting with '#'
    $content = $content -replace '(?<!\$)\bTrue\b', '$true' -replace '(?<!\$)\bFalse\b', '$false'
    $scriptBlock = [scriptblock]::Create($content)
    $data = . $scriptBlock
    return $data
}


# Function Export Psd1
function Export-PowerShellData1 {
    param (
        [Parameter(Mandatory = $true)]
        [hashtable]$Data,
        [Parameter(Mandatory = $true)]
        [string]$Path,
        [switch]$Name
    )

    function ConvertTo-Psd1Content {
        param ($Value)
        switch ($Value) {
            { $_ -is [System.Collections.Hashtable] } {
                $innerContent = $Value.GetEnumerator() | ForEach-Object {
                    "`n    $($_.Key) = $(ConvertTo-Psd1Content $_.Value)"
                }
                return "@{$innerContent`n}"
            }
            { $_ -is [System.Collections.IEnumerable] -and $_ -isnot [string] } {
                $arrayContent = $Value | ForEach-Object { ConvertTo-Psd1Content $_ }
                return "@($arrayContent -join ', ')"
            }
            { $_ -is [PSCustomObject] } {
                $hashTable = @{}
                $_.psobject.properties | ForEach-Object { $hashTable[$_.Name] = $_.Value }
                return ConvertTo-Psd1Content $hashTable
            }
            { $_ -is [string] } { return "`"$Value`"" }
            { $_ -is [int] -or $_ -is [long] -or $_ -is [bool] -or $_ -is [double] -or $_ -is [decimal] } { return $_.ToString() }
            default { return "`"$Value`"" }
        }
    }

    $fileName = if ($Name) { Split-Path $Path -Leaf } else { $null }
    $psd1Content = if ($fileName) { "# Script: $fileName`n`n" } else { "" }
    $psd1Content += "@{"
    $Data.GetEnumerator() | ForEach-Object {
        $psd1Content += "`n    $($_.Key) = $(ConvertTo-Psd1Content $_.Value)"
    }
    $psd1Content += "`n}"
    Set-Content -Path $Path -Value $psd1Content -Force
}
