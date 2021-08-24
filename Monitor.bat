@ECHO OFF

REM : Monitors the program and exits given certain circumstances


:Initialization
	REM : Make sure this is a child program of "Main.bat" in the CMD Display Engine directory.
	IF "%MAIN_TITLE%" == "" IF "%INPUTS_TITLE%" == "" IF "%ENCODER_TITLE%" == "" IF "%MONITOR_TITLE%" == "" (
		ECHO Run the parent of this file & EXIT 
	)
	
	REM : Set the current working directory as the file location.
	CD /D %~dp0
	
	TITLE %MONITOR_TITLE%

	
:Loop
	REM : Exits if master file or input slave are exited.
	TASKLIST /fi "WINDOWTITLE eq %MAIN_TITLE%" | FIND /I "cmd.exe" && ( CALL ) || ( GOTO :End )
	TASKLIST /fi "WINDOWTITLE eq %INPUTS_TITLE%" | FIND /I "cmd.exe" && ( CALL ) || ( GOTO :End )
GOTO :Loop


:End
	TASKKILL /FI "WINDOWTITLE eq %MAIN_TITLE%"
	TASKKILL /FI "WINDOWTITLE eq %INPUTS_TITLE%"
	TASKKILL /FI "WINDOWTITLE eq %ENCODER_TITLE%"
	EXIT