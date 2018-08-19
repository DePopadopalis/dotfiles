$CONEMU_CONFIG_DIR = "C:\tools\cmder\vendor\conemu-maximus5" 

If (-NOT (Test-Path $CONEMU_CONFIG_DIR)){
	md $CONEMU_CONFIG_DIR
}

Copy-Item -Path .\ConEmu.xml -Destination $CONEMU_CONFIG_DIR\ConEmu.xml