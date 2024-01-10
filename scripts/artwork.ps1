# Script: artwork.ps1

# Function Show Title
function Show-Title {
    Write-Host "`n======================( BethDdsScale-Ps )======================`n"
}

# Function Show Divider
function Show-Divider {
	Write-Host "---------------------------------------------------------------"
}

# Function Show Asciiart
function Show-AsciiArt {
    $asciiArt = @"
  ____       _   _     ____      _     ____            _      
 | __ )  ___| |_| |__ |  _ \  __| |___/ ___|  ___ ___ | | ___ 
 |  _ \ / _ \ __|  _ \| | | |/ _  / __\___ \ / __/ _ \| |/ _ \
 | |_) |  __/ |_| | | | |_| | (_| \__ \___) | (_| (_| | |  __/
 |____/ \___|\__|_| |_|____/ \__,_|___/____/ \___\__,_|_|\___|
"@
    Write-Host $asciiArt
}
