$CONEMU_CONFIG_DIR = "C:\tools\cmder\vendor\conemu-maximus5" 

If (-NOT (Test-Path $CONEMU_CONFIG_DIR)){
	Write-Host "Config directory not found"
	Exit
}

$Overwrite = Read-Host -Prompt "Do you want to overwrite ConEmu.xml [Y]es or [N]o? [Y]"
if ($Overwrite -eq "Y" -OR $Overwrite -eq "y" -OR $Overwrite -eq ""){
    Copy-Item -Path $CONEMU_CONFIG_DIR\ConEmu.xml -Destination .\ConEmu.xml
}
else{
    Copy-Item -Path $CONEMU_CONFIG_DIR\ConEmu.xml -Destination .\Current_ConEmu.xml    
}
