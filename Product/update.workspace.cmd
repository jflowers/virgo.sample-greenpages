@echo off
call ..\Build\set.env.cmd
cd ..
TortoiseProc.exe /command:pull /path:"%CD%"
::IF %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%
cd Build\chef
echo Starting Chef to update your workspace...
call run-solo.cmd
cd ..\..\Product
IF %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%