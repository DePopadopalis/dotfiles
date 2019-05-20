#requires -Version 2 -Modules posh-git

function Write-Theme {

    param(
        [bool]
        $lastCommandFailed,
        [string]
        $with
    )

    # Set background color for special symbols and dividers before session info
    $lastBackgroundColor = $sl.Colors.SessionInfoBackgroundColor
    $sectionSegmentForwardSymbol = $sl.PromptSymbols.TopSegmentForwardSymbol

    # check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $sl.Colors.CurrentAdminIconForegroundColor = [ConsoleColor]::DarkRed
        $sl.Colors.CurrentPathBackgroundColor = $sl.Colors.PathBackgroundColor
        $sl.Colors.CurrentPathForegroundColor = $sl.Colors.PathForegroundColor
        $sl.Colors.CurrentSessionInfoBackgroundColor = [ConsoleColor]::DarkRed
        $sl.Colors.CurrentSessionInfoForegroundColor = [ConsoleColor]::Black
        $lastBackgroundColor = [ConsoleColor]::DarkRed
    }
    Else {
        $sl.Colors.CurrentAdminIconForegroundColor = $sl.Colors.AdminIconForegroundColor
        $sl.Colors.CurrentPathBackgroundColor = $sl.Colors.PathBackgroundColor
        $sl.Colors.CurrentPathForegroundColor = $sl.Colors.PathForegroundColor
        $sl.Colors.CurrentSessionInfoBackgroundColor = $sl.Colors.SessionInfoBackgroundColor
        $sl.Colors.CurrentSessionInfoForegroundColor = $sl.Colors.SessionInfoForegroundColor
    }
    ### PROMPT FIRST LINE ###
    $prompt = Write-Prompt -Object $sl.PromptSymbols.TopStartSymbol -BackgroundColor $sl.Colors.TerminalBackgroundColor -ForegroundColor $lastBackgroundColor

    # Session section begin
    # Individual character divider
    # $prompt += Write-Prompt -Object "$($sl.PromptSymbols.CharacterSegmentDivider) " -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.SegmentDividerColor
    # Full section divider
    # $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $lastBackgroundColor

    # Write user/host info to line
    $user = [System.Environment]::UserName
    # $computer = Get-ComputerName
    if (Test-NotDefaultUser($user)) {
        $prompt += Write-Prompt -Object "$user" -BackgroundColor $sl.Colors.CurrentSessionInfoBackgroundColor -ForegroundColor $sl.Colors.CurrentSessionInfoForegroundColor
        $lastBackgroundColor = $sl.Colors.CurrentSessionInfoBackgroundColor
    }

    # Separate sessioninfo and path
    $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.TerminalBackgroundColor
    $lastBackgroundColor = $sl.Colors.TerminalBackgroundColor

    # Write path to terminal portion
    # $path += Get-ShortPath -dir $pwd
    $path += Get-FullPath -dir $pwd
    $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.CurrentPathBackgroundColor
    $prompt += Write-Prompt -Object " $($path) " -BackgroundColor $sl.Colors.CurrentPathBackgroundColor -ForegroundColor $sl.Colors.CurrentPathForegroundColor
    $lastBackgroundColor = $sl.Colors.CurrentPathBackgroundColor

    # Virtual Environment
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object " $($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor -ForegroundColor $sl.Colors.VirtualEnvForegroundColor
        $lastBackgroundColor = $sl.Colors.VirtualEnvBackgroundColor 
    }
    else {
        
    }

    # Git Prompt
    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $themeInfo.BackgroundColor
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $themeInfo.BackgroundColor -ForegroundColor $sl.Colors.GitForegroundColor
        $lastBackgroundColor = $themeInfo.BackgroundColor
    }

    if ($with) {
        $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $sl.Colors.StartSymbolBackgroundColor -ForegroundColor $lastBackgroundColor
        $prompt += Write-Prompt -Object " $($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
        $lastBackgroundColor = $sl.Colors.WithBackgroundColor
    }

    # Write top line end cap
    $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.TerminalBackgroundColor

    ### PROMPT SECOND LINE ###
    $lastBackgroundColor = $sl.Colors.TerminalBackgroundColor
    $sectionSegmentForwardSymbol = $sl.PromptSymbols.BottomSegmentForwardSymbol
    $prompt += Set-Newline

    # check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.ElevatedSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.CurrentAdminIconForegroundColor
    }

    # Writes the postfix to the prompt
    $prompt += Write-Prompt -Object $sectionSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.TerminalForegroundColor
    $prompt += ' '
    $prompt
}

# 0  - Black       -    snow
# 1  - DarkBlue    -    blue
# 2  - DarkGreen   -    darkseagreen
# 3  - DarkCyan    -    cerulean
# 4  - DarkRed     -    crimson
# 5  - DarkMagenta -    purple
# 6  - DarkYellow  -    goldenrod
# 7  - Gray        -    dimgray
# 8  - DarkGray    -    black
# 9  - Blue        -    deepskyblue
# 10 - Green       -    seagreen
# 11 - Cyan        -    ice_blue
# 12 - Red         -    orange
# 13 - Magenta     -    bright_green
# 14 - Yellow      -    gold
# 15 - White       -    dark_teal

$sl = $global:ThemeSettings #local settings

# Define Symbols
$sl.PromptSymbols.TopStartSymbol = [char]::ConvertFromUtf32(0xe0b6)
$sl.PromptSymbols.FailedCommandSymbol = [char]::ConvertFromUtf32(0xf00d)
$sl.PromptSymbols.ElevatedSymbol = [char]::ConvertFromUtf32(0xe614)

$sl.PromptSymbols.TopSegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0be)
$sl.PromptSymbols.BottomSegmentForwardSymbol = [char]::ConvertFromUtf32(0xe285)

# Define Colors
$sl.Colors.TerminalBackgroundColor = [ConsoleColor]::Black
$sl.Colors.TerminalForegroundColor = [ConsoleColor]::White

$sl.Colors.StartSymbolBackgroundColor = [ConsoleColor]::Black
$sl.Colors.CommandFailedIconForegroundColor = [ConsoleColor]::Yellow
$sl.Colors.AdminIconForegroundColor = [ConsoleColor]::White

$sl.Colors.SessionInfoBackgroundColor = [ConsoleColor]::White
$sl.Colors.SessionInfoForegroundColor = [ConsoleColor]::Black

$sl.Colors.PathBackgroundColor = [ConsoleColor]::White
$sl.Colors.PathForegroundColor = [ConsoleColor]::Black

$sl.Colors.PromptHighlightColor = [ConsoleColor]::Yellow

$sl.Colors.GitDefaultColor = [ConsoleColor]::Cyan
$sl.Colors.GitForegroundColor = [ConsoleColor]::DarkGray
$sl.Colors.GitLocalChangesColor = [ConsoleColor]::Red
$sl.Colors.GitNoLocalChangesAndAheadColor = [ConsoleColor]::Yellow

# ???
$sl.Colors.WithForegroundColor = [ConsoleColor]::White
$sl.Colors.WithBackgroundColor = [ConsoleColor]::DarkRed
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::DarkGray
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::Black
