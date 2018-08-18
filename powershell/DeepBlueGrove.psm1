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

    ### PROMPT FIRST LINE ###
    # Initial Symbol
    # $prompt = Write-Prompt -Object $sl.PromptSymbols.TopStartSymbol -ForegroundColor $sl.Colors.InitialSectionForegroundColor -BackgroundColor $sl.Colors.StartSymbolBackgroundColor

    # Check if additional icons need to be added
    # check the last command state and indicate if failed
    If ($lastCommandFailed) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.FailedCommandSymbol) " -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.CommandFailedIconForegroundColor
    }
    # check for elevated prompt
    If (Test-Administrator) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.ElevatedSymbol) " -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.AdminIconForegroundColor
    }

    # Session section begin
    # Individual character divider
    # $prompt += Write-Prompt -Object "$($sl.PromptSymbols.CharacterSegmentDivider) " -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.SegmentDividerColor
    # Full section divider
    # $prompt += Write-Prompt -Object "$($sl.PromptSymbols.TopSegmentForwardSymbol) " -BackgroundColor $lastBackgroundColor -ForegroundColor $lastBackgroundColor

    # Write user/host info to line
    # $user = [System.Environment]::UserName
    $user = "depop"
    $computer = Get-ComputerName
    if (Test-NotDefaultUser($user)) {
        $prompt += Write-Prompt -Object " $user@$computer " -BackgroundColor $sl.Colors.SessionInfoBackgroundColor -ForegroundColor $sl.Colors.SessionInfoForegroundColor
        $lastBackgroundColor = $sl.Colors.SessionInfoBackgroundColor
    }

    # This always happens?
    if (Test-VirtualEnv) {
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.TopSegmentForwardSymbol) " -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.VirtualEnvBackgroundColor
        $prompt += Write-Prompt -Object "$($sl.PromptSymbols.VirtualEnvSymbol) $(Get-VirtualEnvName) " -BackgroundColor $sl.Colors.VirtualEnvBackgroundColor -ForegroundColor $sl.Colors.VirtualEnvForegroundColor
        $lastBackgroundColor = $sl.VirtualEnvBackgroundColor
    }
    else {
        
    }

    # Git Prompt
    $status = Get-VCSStatus
    if ($status) {
        $themeInfo = Get-VcsInfo -status ($status)
        $prompt += Write-Prompt -Object $sl.PromptSymbols.TopSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $themeInfo.BackgroundColor
        $prompt += Write-Prompt -Object " $($themeInfo.VcInfo) " -BackgroundColor $themeInfo.BackgroundColor -ForegroundColor $sl.Colors.GitForegroundColor
        $lastBackgroundColor = $themeInfo.BackgroundColor
    }

    if ($with) {
        $prompt += Write-Prompt -Object $sl.PromptSymbols.TopSegmentForwardSymbol -BackgroundColor $sl.Colors.StartSymbolBackgroundColor -ForegroundColor $lastBackgroundColor
        $prompt += Write-Prompt -Object " $($with.ToUpper()) " -BackgroundColor $sl.Colors.WithBackgroundColor -ForegroundColor $sl.Colors.WithForegroundColor
        $lastBackgroundColor = $sl.Colors.WithBackgroundColor
    }

    # Write top line end cap
    $prompt += Write-Prompt -Object $sl.PromptSymbols.TopSegmentForwardSymbol -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.TerminalBackgroundColor

    ### PROMPT SECOND LINE ###
    $lastBackgroundColor = $sl.Colors.TerminalBackgroundColor
    $prompt += Set-Newline

    # Write path to terminal portion
    # $path += Get-ShortPath -dir $pwd
    $path += Get-FullPath -dir $pwd
    $prompt += Write-Prompt -Object (Get-FullPath -dir $pwd) -BackgroundColor $sl.Colors.PathBackgroundColor -ForegroundColor $sl.Colors.PathForegroundColor
    $lastBackgroundColor = $sl.Colors.PathBackgroundColor

    # Writes the postfix to the prompt
    $prompt += Write-Prompt -Object "$($sl.PromptSymbols.BottomSegmentForwardSymbol)" -BackgroundColor $lastBackgroundColor -ForegroundColor $sl.Colors.TerminalBackgroundColor
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
$sl.PromptSymbols.TopStartSymbol = ""
$sl.PromptSymbols.FailedCommandSymbol = [char]::ConvertFromUtf32(0xe20d)
$sl.PromptSymbols.ElevatedSymbol = [char]::ConvertFromUtf32(0xf0e7)

$sl.PromptSymbols.CharacterSegmentDivider = [char]::ConvertFromUtf32(0xE0d4)
$sl.PromptSymbols.TopSegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0be)
$sl.PromptSymbols.BottomSegmentForwardSymbol = [char]::ConvertFromUtf32(0xE0ba)

# Define Colors
$sl.Colors.TerminalBackgroundColor = [ConsoleColor]::Black

$sl.Colors.StartSymbolBackgroundColor = [ConsoleColor]::Black
$sl.Colors.SegmentDividerColor = [ConsoleColor]::Yellow

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
$sl.Colors.VirtualEnvBackgroundColor = [System.ConsoleColor]::Red
$sl.Colors.VirtualEnvForegroundColor = [System.ConsoleColor]::White
