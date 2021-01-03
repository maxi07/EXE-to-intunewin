@echo off
cls
echo ==============================================
echo      CREATE .INTUNEWIN FROM .EXE OR .MSI
echo ==============================================
echo Support: maxi@pagesmedia.de
echo Version 1.2 - 03.01.2021
echo The script downloads the IntuneWinAppUtil from GitHub and creates .intunewin files for Azure Intune
echo.
echo Creating working directory on your Desktop
set rootdir=%USERPROFILE%\Desktop\IntuneWinAppUtil\
if EXIST %rootdir% ( rmdir /S /Q %rootdir% )
mkdir %rootdir%
mkdir %rootdir%incoming
mkdir %rootdir%tool
echo Downloading latest version of content prep tool from GitHub
SET intunefile=%rootdir%tool\IntuneWinAppUtil.exe
start /wait bitsadmin /transfer intune /download /priority FOREGROUND "https://github.com/microsoft/Microsoft-Win32-Content-Prep-Tool/raw/master/IntuneWinAppUtil.exe" %intunefile%
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



:build
echo Starting build workflow
call %intunefile% -c %rootdir%incoming\ -s %setupfile% -o %rootdir%
echo.
echo Finished!
start %rootdir%
pause
exit