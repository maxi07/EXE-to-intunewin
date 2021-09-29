@echo off
title Updater
echo Will now update EXE to intunewin
del IntuneSetupFile.bat
ren IntuneSetupFile-Latest.bat IntuneSetupFile.bat
goto 2>nul & del "%~f0"
exit