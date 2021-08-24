@ECHO OFF

REM : Monitors Inputs in the window and transfers the output to %INPUT_FILENAME%.


:Initialization
	REM : Make sure this is a child program of "Main.bat" in the CMD Display Engine directory.
	IF "%INPUT_FILENAME%" == "" IF "%INPUTS_TITLE%" == "" IF "%INPUT_CHOICE%" == "" (
		IF "%WIDTH%" == "" IF "%BACKCOLOR%" == "" IF "%TEXTCOLOR%" == "" (
			ECHO Run the parent of this file & EXIT
		)
	)
	
	REM : Set the current working directory as the file location.
	CD /D %~dp0
	
	SET INPUT_FILENAME=%INPUT_FILENAME%
	SET output=0
	
	MODE con: cols=%WIDTH% lines=3
	COLOR %BACKCOLOR%%TEXTCOLOR%
	TITLE %INPUTS_TITLE%


:InputLoop
	CHOICE /C %INPUT_CHOICE% > NUL
	START "%ENCODER_TITLE%" /MIN CMD /C Encoder.bat %ERRORLEVEL% %INPUT_FILENAME%

GOTO InputLoop

