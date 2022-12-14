@ECHO off

CLS

TITLE KOTOR REGISTRY INSTALL PATH EDITOR

ECHO   -------------------------------------------------------------------------------------
ECHO:
ECHO                            KOTOR REGISTRY INSTALL PATH EDITOR
ECHO:
ECHO		Scans the registry for any existing installations of K1 and TSL and outputs
ECHO		the install path designated for the game. Allows you to set the install path
ECHO		of the CD version's key for use with KOTOR Tool, etc., including creating a
ECHO		new key if one doesn't already exist.
ECHO:
ECHO		N.B. Depending on your Windows account permissions, you may need to run this
ECHO		script as an administrator.
ECHO:
ECHO   -------------------------------------------------------------------------------------

:scan_reg

SET "PathK1CD="
SET "PathK1GOG="
SET "PathK1Steam="
SET "PathK1Origin="
SET "PathTSLCD="
SET "PathTSLGOG="
SET "PathTSLSteam="
SET "PathTSLOrigin="

ECHO:
ECHO   Scanning the registry for K1 keys:
ECHO:

@FOR /f "tokens=2*" %%i in ('REG QUERY "HKLM\SOFTWARE\BioWare\SW\KOTOR" /v "Path" /reg:32 2^>Nul') DO SET "PathK1CD=%%j"
IF DEFINED PathK1CD (
						ECHO		K1 CD version registry key found.
						ECHO		Install path = %PathK1CD%
						ECHO:
				) ELSE (
						ECHO		No K1 CD version registry key found.
						ECHO:
				)

@FOR /f "tokens=2*" %%i in ('REG QUERY "HKLM\SOFTWARE\GOG.com\Games\1207666283" /v "PATH" /reg:32 2^>Nul') DO SET "PathK1GOG=%%j"
IF DEFINED PathK1GOG (
						ECHO		K1 GOG version registry key found.
						ECHO		Install path = %PathK1GOG%
						ECHO:
				) ELSE (
						ECHO		No K1 GOG version registry key found.
						ECHO:
				)

@FOR /f "tokens=2*" %%i in ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 32370" /v "InstallLocation" 2^>Nul') DO SET "PathK1Steam=%%j"
IF DEFINED PathK1Steam (
						ECHO		K1 Steam version registry key found.
						ECHO		Install path = %PathK1Steam%
						ECHO:
				) ELSE (
						ECHO		No K1 Steam version registry key found.
						ECHO:
				)

ECHO:
ECHO   Scanning the registry for TSL keys:
ECHO:

@FOR /f "tokens=2*" %%i in ('REG QUERY "HKLM\SOFTWARE\LucasArts\KOTOR2" /v "Path" /reg:32 2^>Nul') DO SET "PathTSLCD=%%j"
IF DEFINED PathTSLCD (
						ECHO		TSL CD version registry key found.
						ECHO		Install path = %PathTSLCD%
						ECHO:
				) ELSE (
						ECHO		No TSL CD version registry key found.
						ECHO:
				)

@FOR /f "tokens=2*" %%i in ('REG QUERY "HKLM\SOFTWARE\GOG.com\Games\1421404581" /v "PATH" /reg:32 2^>Nul') DO SET "PathTSLGOG=%%j"
IF DEFINED PathTSLGOG (
						ECHO		TSL GOG version registry key found.
						ECHO		Install path = %PathTSLGOG%
						ECHO:
				) ELSE (
						ECHO		No TSL GOG version registry key found.
						ECHO:
				)

@FOR /f "tokens=2*" %%i in ('REG QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Steam App 208580" /v "InstallLocation" 2^>Nul') DO SET "PathTSLSteam=%%j"
IF DEFINED PathTSLSteam (
						ECHO		TSL Steam version registry key found.
						ECHO		Install path = %PathTSLSteam%
						ECHO:
				) ELSE (
						ECHO		No TSL Steam version registry key found.
						ECHO:
				)

ECHO:

:redirect
ECHO   Please choose your desired operation:
ECHO:
ECHO		1) Scan the registry for installed game version keys
ECHO		2) Edit the K1 CD version registry key install path
ECHO		3) Edit the TSL CD version registry key install path
ECHO		4) Exit
ECHO:
CHOICE /C:1234 /N /M "		Enter your choice number:		"
IF ERRORLEVEL 4 GOTO :exit
IF ERRORLEVEL 3 GOTO :start_tsl_key
IF ERRORLEVEL 2 GOTO :start_k1_key
IF ERRORLEVEL 1 GOTO :scan_reg

:start_k1_key
IF "%PathK1CD%"=="" (
		CHOICE /m "		The K1 CD version registry key does not exist. Do you want to create it?"
		IF ERRORLEVEL 2 GOTO :redirect
		IF ERRORLEVEL 1 GOTO :create_k1_key
) ELSE ( GOTO :change_k1_key )

:change_k1_key
CHOICE /m "		Do you want to change the existing K1 CD version registry key install path value?"
IF ERRORLEVEL 2 GOTO :redirect
IF ERRORLEVEL 1 GOTO :create_k1_key

:create_k1_key
ECHO   Select which game version install path you want to use:
ECHO:
ECHO		1) Use GOG path
ECHO		2) Use Steam path
ECHO		3) Cancel
ECHO:
CHOICE /C:123 /N /M "		Enter your choice number:		"
IF ERRORLEVEL 3 GOTO :redirect
IF ERRORLEVEL 2 IF DEFINED PathK1Steam (
						REG ADD "HKLM\SOFTWARE\BioWare\SW\KOTOR" /v Path /d "%PathK1Steam%" /reg:32 /f >nul 2>&1 
						ECHO		Created K1 CD version registry key using Steam path.
						ECHO:
						GOTO :redirect
					) ELSE (
						ECHO		No K1 Steam version registry key found!
						GOTO :create_k1_key
					)
)
IF ERRORLEVEL 1 IF DEFINED PathK1GOG (
						REG ADD "HKLM\SOFTWARE\BioWare\SW\KOTOR" /v Path /d "%PathK1GOG%" /reg:32 /f >nul 2>&1 
						ECHO		Created K1 CD version registry key using GOG path.
						ECHO:
						GOTO :redirect
					) ELSE (
						ECHO		No K1 GOG version registry key found!
						GOTO :create_k1_key
					)
)

:start_tsl_key
IF "%PathTSLCD%"=="" (
		CHOICE /m "		The TSL CD version registry key does not exist. Do you want to create it?"
		IF ERRORLEVEL 2 GOTO :redirect
		IF ERRORLEVEL 1 GOTO :create_tsl_key
) ELSE ( GOTO :change_tsl_key )

:change_tsl_key
CHOICE /m "		Do you want to change the existing TSL CD version registry key install path value?"
IF ERRORLEVEL 2 GOTO :redirect
IF ERRORLEVEL 1 GOTO :create_tsl_key

:create_tsl_key
ECHO   Select which game version install path you want to use:
ECHO:
ECHO		1) Use GOG path
ECHO		2) Use Steam path
ECHO		3) Cancel
ECHO:
CHOICE /C:123 /N /M "		Enter your choice number:		"
IF ERRORLEVEL 3 GOTO :redirect
IF ERRORLEVEL 2 IF DEFINED PathTSLSteam (
						REG ADD "HKLM\SOFTWARE\BioWare\LucasArts\KOTOR2" /v Path /d "%PathTSLSteam%" /reg:32 /f >nul 2>&1 
						ECHO		Created TSL CD version registry key using Steam path.
						ECHO:
						GOTO :redirect
					) ELSE (
						ECHO		No TSL Steam version registry key found!
						GOTO :create_tsl_key
					)
)
IF ERRORLEVEL 1 IF DEFINED PathTSLGOG (
						REG ADD "HKLM\SOFTWARE\BioWare\LucasArts\KOTOR2" /v Path /d "%PathTSLGOG%" /reg:32 /f >nul 2>&1 
						ECHO		Created TSL CD version registry key using GOG path.
						ECHO:
						GOTO :redirect
					) ELSE (
						ECHO		No TSL GOG version registry key found!
						GOTO :create_tsl_key
					)
)

:exit
ECHO:
pause
