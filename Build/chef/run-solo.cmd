call ..\set.env.cmd
chef-solo -c %CD%\solo.rb %*
IF %ERRORLEVEL% NEQ 0 exit /B %ERRORLEVEL%