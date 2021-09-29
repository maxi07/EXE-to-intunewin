@echo off
SET currentvers=1.3
cls
echo ==============================================
echo      CREATE .INTUNEWIN FROM .EXE OR .MSI
echo ==============================================
echo Support: maxi@pagesmedia.de
echo Version %currentvers% - 28.09.2021
echo The script downloads the IntuneWinAppUtil from GitHub and creates .intunewin files for Azure Intune
echo.
echo Checking for newest version...
goto getfileversion

:downloadcontentprep
echo Creating working directory on your Desktop
set rootdir=%USERPROFILE%\Desktop\IntuneWinAppUtil\
if EXIST %rootdir% ( rmdir /S /Q %rootdir% )
mkdir %rootdir%
mkdir %rootdir%incoming
mkdir %rootdir%tool
SET intunefile=%rootdir%tool\IntuneWinAppUtil.exe
Ping www.google.de -n 1 -w 1000 > nul
if errorlevel 1 (
echo Not connected to network, will continue with current version.
) else (
echo Connected to network, will download latest version of Windows content prep tool. 
start /wait bitsadmin /transfer intune /download /priority FOREGROUND "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/master/IntuneWinAppUtil.exe" %intunefile%
)

if exist %intunefile% (
	for /f %%i in ('powershell -NoLogo -NoProfile -Command "(Get-Item -Path '%intunefile%').VersionInfo.FileVersion"') do set intuneversion=%%i
) else (
    echo Failed downloading intune setup file from GitHub.
	pause
	exit
)
echo Running intune content prep tool version %intuneversion%
echo Please drop your setup files into the incoming folder on your desktop and press any key when finished.
start %rootdir%incoming
pause
goto dropsetupfile

:dropsetupfile
if EXIST %rootdir%incoming\*.exe goto selectexe
if EXIST %rootdir%incoming\*.msi goto selectmsi
echo No setup file with .exe or .msi was found. Please try again.
pause
goto dropsetupfile
exit


:selectexe
for %%A in (%rootdir%incoming\*.exe) do set setupfile=%%A
if exe == "" (
echo Unable to select exe file.
pause
exit
) else (
echo Found valid .exe file: %setupfile%
goto build
)

:selectmsi
for %%A in (%rootdir%incoming\*.msi) do set setupfile=%%A
if exe == "" (
echo Unable to select exe file.
pause
exit
) else (
echo Found valid .msi file (%setupfile%)
goto build
)

:getfileversion
Ping www.google.de -n 1 -w 1000 > nul
if errorlevel 1 (
	echo Not connected to network, will continue with current version.
) else (
	FOR /F "tokens=* USEBACKQ" %%F IN (`curl -s https://raw.githubusercontent.com/maxi07/EXE-to-intunewin/main/version`) DO (
	SET vers=%%F
))
if %vers% gtr %currentvers% ( 
	goto askupdate
) else (
	goto downloadcontentprep
)

:askupdate
ECHO.
ECHO ===================================================
ECHO Hey, there is an update available!
choice /M "Do you wish to update automatically?"
if %ERRORLEVEL% EQU 2 goto downloadcontentprep
if %ERRORLEVEL% EQU 1 goto update
if %ERRORLEVEL% EQU 0 goto downloadcontentprep

:update
echo Downloading latest update...
curl -L -s https://github.com/maxi07/EXE-to-intunewin/raw/main/IntuneSetupFile.bat >> IntuneSetupFile-Latest.bat
curl -L -s https://github.com/maxi07/EXE-to-intunewin/raw/main/UpdateHelper.bat >> UpdateHelper.bat
pause
echo Downloaded the latest file into current directory.
echo Please wait...
timeout 1
if EXIST UpdateHelper.bat (
	start UpdateHelper.bat
) else (
	echo Failed downloading update!
)
exit


:build
echo Starting build workflow
call %intunefile% -c %rootdir%incoming\ -s %setupfile% -o %rootdir%
echo.
echo Finished!
start %rootdir%
pause
exit