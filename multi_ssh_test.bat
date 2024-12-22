@echo off
setlocal enabledelayedexpansion

set attemptNum=0
set successNum=0
set failNum=0

REM Usage function
:usage
echo Usage: %0 ^<hostname^> ^<num_connections^> ^<duration^>
exit /b 1

REM Check number of arguments
if "%~3"=="" (
    echo Error: Incorrect number of arguments.
    call :usage
)

set hostname=%1
set username=root
set password=0penBmc
set num_connections=%2
set duration=%3

REM Create SSH connection
:createssh
set hostname=%1
set duration=%2
set /a attemptNum+=1

ssh -o StrictHostKeyChecking=no %username%@%hostname% -p %password% "sleep %duration%" >nul 2>&1
if !errorlevel! == 0 (
    set /a successNum+=1
) else (
    set /a failNum+=1
)
exit /b

REM Create connections in batches
:createbatches
set hostname=%1
set duration=%2
set num_connections=%3
set batch_size=50
set delay=1
set /a i=0

:batchloop
if !i! geq !num_connections! goto :batchend
for /L %%j in (0,1,!batch_size!) do (
    if !i! lss !num_connections! (
        call :createssh !hostname! !duration!
        set /a i+=1
    )
)
timeout /t !delay! >nul
goto :batchloop

:batchend

REM Print results
echo Connection Success: !successNum!
echo Connection Fail: !failNum!
echo All connections attempted and closed after the specified duration.

exit /b 0
