@echo off
title TTL Changer 1.4 - AzimsTech
color 1f

:: Check if it running as administator. If not, then prompt an administator request
if not "%1"=="am_admin" (
    TIMEOUT 2 > NUL
    @ECHO :: Requesting administator access...
    powershell -Command "Start-Process -Verb RunAs -FilePath '%0' -ArgumentList 'am_admin'"
    exit /b
)


:MENU
	CLS
	:: Get current TTL value from localhost
	for /f "tokens=6" %%i in ('ping -n 1 127.0.0.1^|find "TTL"') do set ttl="%%i"

	:: Change background color to red if TTL=128 else, green.
	if %ttl% == "TTL=128" ( color 4F ) else ( color A0 )

	
:::   _____ _____ _        ___ _  _   _   _  _  ___ ___ ___ 
:::  |_   _|_   _| |  ___ / __| || | /_\ | \| |/ __| __| _ \
:::    | |   | | | |_|___| (__| __ |/ _ \| .` | (_ | _||   /
:::    |_|   |_| |____|   \___|_||_/_/ \_\_|\_|\___|___|_|_\
	:: Display ASCII art
	for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A
                                                        

	:: Display current TTL value
	echo --------------------------------------------------------------
	echo  Current %ttl%
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
	:: prefer ipv4 over ipv6 https://docs.microsoft.com/en-us/troubleshoot/windows-server/networking/configure-ipv6-in-windows
	reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /t REG_DWORD /d 32 /f
	echo.
	echo Restart now for best results.
	timeout 2 >NUL
	goto MENU

:: TTL set to 128 (default value) & back to menu
:DEFAULT
	netsh int ipv4 set glob defaultcurhoplimit=128 >NUL
	netsh int ipv6 set glob defaultcurhoplimit=128 >NUL
	:: revert prefer ipv4 over ipv6 https://docs.microsoft.com/en-us/troubleshoot/windows-server/networking/configure-ipv6-in-windows
	reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters" /v DisabledComponents /f
	echo.
	echo Restart now for best results.
	timeout 2 >NUL
	goto MENU
