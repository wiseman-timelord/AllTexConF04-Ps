# Script: scripts\artwork.ps1

# Function Show Title
function Show-Title {
    Write-Host "`n======================( DdsBa2Resize-Ps )======================`n"
}

# Function Divider
function Show-Divider {
	Write-Host "---------------------------------------------------------------"
}

# Function AsciiArt
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
