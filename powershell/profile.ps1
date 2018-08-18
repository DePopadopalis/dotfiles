# Import Powershell modules
Import-Module posh-git
Import-Module oh-my-posh

# FUNCTIONS
function U
{
    param
    (
        [int] $Code
    )
 
    if ((0 -le $Code) -and ($Code -le 0xFFFF))
    {
        return [char] $Code
    }
 
    if ((0x10000 -le $Code) -and ($Code -le 0x10FFFF))
    {
        return [char]::ConvertFromUtf32($Code)
    }
 
    throw "Invalid character code $Code"
}

function Put-CursorOnBottom
{
    $rawUI = (Get-Host).UI.RawUI
    $cp = $rawUI.CursorPosition
    $cp.Y = $rawUI.BufferSize.Height - 1
    $rawUI.CursorPosition = $cp
}

function CustomClear
{
    clear
    Put-CursorOnBottom
}

# Set Aliases
# New-Alias which Get-Command   # Not needed with ConEmu
# New-Alias touch New-Item      # Not needed with ConEmu
# Set l and ls alias to use the new Get-ChildItemColor cmdlets
Set-Alias ll Get-ChildItemColor -Option AllScope
Set-Alias ls Get-ChildItemColorFormatWide -Option AllScope
Set-Alias cl CustomClear

# Disable beeping noise
Set-PSReadlineOption -BellStyle None

# Set Powershell colorscheme
# Available color options:
#   White=dark_teal |   Blue=deepskyblue   |   Green=seagreen   |
#   Cyan=ice_blue   |   Red=orange  |   Magenta=bright_green   |
#   Yellow=gold   | Gray=dimgray
#   Black=snow | DarkBlue=blue | DarkGreen=darkseagreen |
#   DarkCyan=cerulean | DarkRed=crimson | DarkMagenta=purple |
#   DarkYellow=goldenrod | DarkGray=black

Set-PSReadlineOption -TokenKind none -ForegroundColor White
Set-PSReadlineOption -TokenKind comment -ForegroundColor Gray
Set-PSReadlineOption -TokenKind keyword -ForegroundColor DarkGray
Set-PSReadlineOption -TokenKind string -ForegroundColor DarkCyan
Set-PSReadlineOption -TokenKind operator -ForegroundColor White
Set-PSReadlineOption -TokenKind variable -ForegroundColor DarkRed
Set-PSReadlineOption -TokenKind command -ForegroundColor White
Set-PSReadlineOption -TokenKind parameter -ForegroundColor DarkRed
Set-PSReadlineOption -TokenKind type -ForegroundColor DarkMagenta
Set-PSReadlineOption -TokenKind number -ForegroundColor Red
Set-PSReadlineOption -TokenKind member -ForegroundColor White

Set-Theme DeepBlueGrove
Put-CursorOnBottom

