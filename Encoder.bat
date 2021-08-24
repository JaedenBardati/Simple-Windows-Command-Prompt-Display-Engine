REM : Set the current working directory as the file location.
CD /D %~dp0
	
REM : Print %errorlevel% of choice in the parent file InputSlave.bat while %INPUT_FILENAME% is not being used.
IF [%~3] == [a] (
	:AppendLoop
		2> NUL (
		  >> %~2 (CALL )
		) && ( ECHO %~1 >> %~2) || ( GOTO :AppendLoop)
	EXIT
)

:WriteLoop
	2> NUL (
	  >> %~2 (CALL )
	) && ( ECHO %~1 > %~2) || ( GOTO :WriteLoop)
EXIT