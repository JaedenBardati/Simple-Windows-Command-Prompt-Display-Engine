@ECHO OFF

:Initialization
	SETLOCAL enableExtensions
	
	REM : Set the current working directory as the file location
	CD /D %~dp0
	
	SET WIDTH=120
	SET HEIGHT=40
	
	SET BACKCOLOR=0
	SET TEXTCOLOR=b
	
	SET "MAIN_TITLE=CMD Display Engine"
	SET "MONITOR_TITLE=Monitor"
	SET "ENCODER_TITLE=Encoder"
	SET "INPUTS_TITLE=Input Slave Window"
	
	SET INPUT_FILENAME=InputDump.txt
	SET RENDER_FILENAME=RenderDump.txt
	
	SET INPUT_CHOICE=WASD
	SET "input="
	
	REM --TEMP--
	SET /A sizeOfSquare=5
	SET /A x=18 & REM (%WIDTH%/2) - %sizeOfSquare%
	SET /A y=3 & REM (%HEIGHT%/2) - %sizeOfSquare%/2
	SET direction=None
	REM /--TEMP--
	
	MODE con: cols=%WIDTH% lines=%HEIGHT%
	COLOR %BACKCOLOR%%TEXTCOLOR%
	TITLE %MAIN_TITLE%
	
	REM --STUFF FOR LATER?--
	SET "spaces=                                                                                                                        "
	FOR /L %%y IN (2, 1, %HEIGHT%) DO (
		SET VALUES[%%y]=%spaces%
	)
	
	FOR /L %%y IN (13, 1, 19) DO (
		SET "VALUES[%%y]=            ---------------------               "
	)
	
	REM /--STUFF FOR LATER?--
	
	START CMD /K InputSlave.bat
	START /MIN CMD /K Monitor.bat
	
	CALL :PrintBlankScreen
	
GOTO Main


:Update
	CALL :GetInputs > NUL 2>&1
	
	IF "%input%" == "W" ( SET direction=North)
	IF "%input%" == "A" ( SET direction=West)
	IF "%input%" == "S" ( SET direction=South)
	IF "%input%" == "D" ( SET direction=East)
	
	IF "%direction%" == "North" ( SET /A y-=1)
	IF "%direction%" == "West"  ( SET /A x-=2)
	IF "%direction%" == "South" ( SET /A y+=1)
	IF "%direction%" == "East"  ( SET /A x+=2)
	
	REM SET direction=None
	
	REM CALL :InsertSquare %sizeOfSquare%, %x%, %y%
	REM CALL :GetRender 2>NUL
EXIT /B 0


:Render
	CLS & CALL :PrintSquare %sizeOfSquare%, %x%, %y% & REM --TEMP--
	
	REM : Render %VALUES%
	REM SETLOCAL enableDelayedExpansion
	REM FOR /L %%y IN (2, 1, %HEIGHT%) DO (
		REM IF "!VALUES[%%y]: =!" == "" (
			REM ECHO:
		REM ) ELSE (
			REM ECHO !VALUES[%%y]!
		REM )
	REM )
	REM ENDLOCAL
	
EXIT /B 0


:Wait
	FOR /L %%x IN (1, 1, %~1) DO (
		PING 127.0.0.1 -n 1 -w> NUL
	)
	
EXIT /B 0


:Main
	CALL :Render
	CALL :Wait 2
	CALL :Update
GOTO :Main


:End
	ENDLOCAL
EXIT



REM : FUNCTIONS

:InsertSquare
	REM : Inserts values into %VALUES[y]% to be printed to the screen.
	SETLOCAL
	
	SET /A xsize=%~1 * 175 / 100
	SET ysize=%~1
	
	SET /A xloc=%~2
	SET /A yloc=%~3
	
	SET /A xloc2=%xloc%+%xsize%
	SET /A yloc2=%yloc%+%ysize%
	
	SET /A xsize2=%WIDTH%-%xloc2%
	SET /A ysize2=%HEIGHT%-%yloc2%
	
	REM : Update values in %VALUES[y]%
	SETLOCAL enableDelayedExpansion
	FOR /L %%y IN (%yloc%, 1, %yloc2%) DO (
		SET "content="
		
		REM : If it is on of the top or bottom of the square.
		REM : Otherwise if it is in the middle of the square.
		
		SET var=F
		IF %%y == %yloc% SET var=T
		IF %%y == %yloc2% SET var=T
		IF !var! == T ( ( FOR /L %%x IN (1, 1, %xsize%) DO SET "content=!content!-" ) & SET "content=!VALUES[%%y]:~0,%xloc%!+!content!+!VALUES[%%y]:~%xloc2%,%xsize2%!" )
		IF !var! == F ( SET "content=!VALUES[%%y]:~0,%xloc%!^^^|!spaces:~0,%xsize%!^^^|!VALUES[%%y]:~%xloc2%,%xsize2%!" )
		REM ECHO !content:~0,%WIDTH%!
		REM PAUSE
		START "%ENCODER_TITLE%" /MIN CMD /K Encoder.bat "!content!N%%y" ""%RENDER_FILENAME%"" "a"
	)
	ENDLOCAL & ENDLOCAL
EXIT /B 0
	

:GetRender
	REM : Adjusts %VALUES[%%y]% to the value decoded from %RENDER_FILENAME% and empties the file afterwards.
	2> NUL (
		>> %RENDER_FILENAME% (CALL )
	) && (
		SET "line="
		FOR /F "tokens=1,2 delims=N" %%a IN (%RENDER_FILENAME%) DO (
			SETLOCAL enableDelayedExpansion
			SET line=%%a
			SET /A yloc=%%b 
			REM ECHO !line!-- "!yloc!"
			REM PAUSE
			(ENDLOCAL & SET VALUES[!yloc!]=%line%)
		)
		SET VALUES && PAUSE
		REM ECHO Refreshing . . .
		BREAK > %RENDER_FILENAME%
	) || (CALL :GetRender)

EXIT /B 0


:GetInputs
	REM : Returns input as the value decoded from %INPUT_FILENAME% and empties the file afterwards.
	2> NUL (
		>> %INPUT_FILENAME% (CALL )
	) && (
		SET "input="
		FOR /F "tokens=1 delims= " %%a IN (%INPUT_FILENAME%) DO (
			IF %%a == 1 ( SET input=%INPUT_CHOICE:~0,1%)
			IF %%a == 2 ( SET input=%INPUT_CHOICE:~1,1%)
			IF %%a == 3 ( SET input=%INPUT_CHOICE:~2,1%)
			IF %%a == 4 ( SET input=%INPUT_CHOICE:~3,1%)
		)
		BREAK > %INPUT_FILENAME%
	) || (CALL :GetInputs)

EXIT /B 0


:PrintBlankScreen
	SETLOCAL
	
	SET /A numNewlines=%HEIGHT% - 1
	FOR /L %%x IN (1, 1, %numNewlines%) DO (
		ECHO:
	)
	
	ENDLOCAL
EXIT /B 0


:PrintSquare
	SETLOCAL 
	
	SET /A xsize=%~1 * 175 / 100
	SET ysize=%~1
	
	SET xloc=%~2
	SET yloc=%~3
	
	REM : Top space buffer
	FOR /L %%y IN (1, 1, %yloc%) DO (
		ECHO:
	)
	
	REM : Square filled with spaces
	FOR /L %%y IN (1, 1, %ysize%) DO (
		SETLOCAL enableDelayedExpansion
		
		SET var=F
		IF %%y == 1 (SET var=T)
		IF %%y == %ysize% (SET var=T)
		IF !var! == T (
			REM : If it is on of the top or bottom of the square.
			
			SET "content="
			FOR /L %%x IN (1, 1, %xsize%) DO (
				SET "content=!content!-"
			)
			
			SET "content=!spaces:~0,%xloc%!+!content!+!spaces!"
			ECHO !content:~0,%WIDTH%!
		) ELSE (
			REM : Otherwise if it is in the middle of the square.
			
			SET "content=!spaces:~0,%xloc%!|!spaces:~0,%xsize%!|!spaces!"
			ECHO !content:~0,%WIDTH%!
		)
		
		ENDLOCAL
	)
	
	REM : Bottom space buffer
	SET /A restofymovement=%HEIGHT% - (%yloc% + %ysize%)-1
	FOR /L %%y IN (1, 1, %restofymovement%) DO (
		ECHO:
	)
  
	ENDLOCAL 
EXIT /B 0

