# Import Powershell modules
Import-Module posh-git

# Set Aliases
New-Alias which Get-Command
New-Alias touch New-Item

# Disable beeping noise
Set-PSReadlineOption -BellStyle None

# Set Powershell colorscheme
# Available color options:
#   White |   Blue   |   Green   |   Cyan   |   Red   |   Magenta   |   Yellow   | Gray
#   Black | DarkBlue | DarkGreen | DarkCyan | DarkRed | DarkMagenta | DarkYellow | DarkGray
Set-PSReadlineOption -TokenKind comment -ForegroundColor Black
Set-PSReadlineOption -TokenKind none -ForegroundColor DarkBlue
Set-PSReadlineOption -TokenKind command -ForegroundColor DarkGreen
Set-PSReadlineOption -TokenKind parameter -ForegroundColor DarkGray
Set-PSReadlineOption -TokenKind variable -ForegroundColor DarkRed
Set-PSReadlineOption -TokenKind type -ForegroundColor DarkBlue
Set-PSReadlineOption -TokenKind number -ForegroundColor DarkMagenta
Set-PSReadlineOption -TokenKind string -ForegroundColor Black
Set-PSReadlineOption -TokenKind operator -ForegroundColor DarkBlue
Set-PSReadlineOption -TokenKind member -ForegroundColor DarkBlue