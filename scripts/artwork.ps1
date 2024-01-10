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
   ____      _     ____        ____  ____           _         
  |  _ \  __| |___| __ )  ____|___ \|  _ \ ___  ___(_)_______ 
  | | | |/ _  / __|  _ \ / _  \ __) | |_) / _ \/ __| |_  / _ \
  | |_| | (_| \__ \ |_) | (_| |/ __/|  _ <  __/\__ \ |/ /  __/
  |____/ \__,_|___/____/ \__,_|_____|_| \_\___||___/_/___\___|
"@
    Write-Host $asciiArt
}
