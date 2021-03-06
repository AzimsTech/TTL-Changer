@echo off
title TTL Changer 1.2 - AzimsTech
color 1f

:: Check if it running as administator. If not, then prompt an administator request
call :CHECKADMIN

 if %errorlevel% == 0 (
    goto :MENU
 ) else (
    echo Requesting administrative privileges...
    timeout 1
    goto :UACPROMPT
 )
 exit /b

:CHECKADMIN
    fsutil dirty query %systemdrive% >nul
 exit /b

:: Prompt an administator request
:UACPROMPT
   echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
   echo UAC.ShellExecute "cmd.exe", "/c %~s0 %~1", "", "runas", 1 >> "%temp%\getadmin.vbs"

   "%temp%\getadmin.vbs"
   del "%temp%\getadmin.vbs"
exit /b`


:MENU
	CLS
	:: Get current TTL value from localhost
	for /f "tokens=6" %%i in ('ping -n 1 127.0.0.1^|find "TTL"') do set ttl="%%i"
	set ttl=%ttl:"=%
	echo.

	:: Display current TTL value
	echo --------------------------------------------------------------
	echo Current %ttl%
	echo --------------------------------------------------------------
	echo.
	echo [1] 60 (bypass)
	echo [2] 128 (default)
	echo [3] Exit
	echo.

	:: Get user input
	CHOICE /C:123
	echo.

	if errorlevel 1 set M=1
	if errorlevel 2 set M=2
	if errorlevel 3 set M=3
	if %M%==1 goto BYPASS
	if %M%==2 goto DEFAULT
	if %M%==3 goto EOF
 exit /b

:: TTL set to 65 (bypass) & back to menu
:BYPASS
	netsh int ipv4 set glob defaultcurhoplimit=60 >NUL
	netsh int ipv6 set glob defaultcurhoplimit=60 >NUL
	echo Sucess! 
	timeout 1 >NUL
	goto MENU

:: TTL set to 128 (default value) & back to menu
:DEFAULT
	netsh int ipv4 set glob defaultcurhoplimit=128 >NUL
	netsh int ipv6 set glob defaultcurhoplimit=128 >NUL
	echo Sucess!
	timeout 1 >NUL
	goto MENU




