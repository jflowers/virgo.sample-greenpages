for /r "%HOMEDRIVE%%HOMEPATH%\.m2" %%X in (*com.springsource.org.h2-1.0.71.jar) do (set H2CP=%H2CP%;%%X)

if "%H2CP%" == "" (goto h2NotFound) else goto end

:h2NotFound
echo Cannot find H2 jars in .m2 Maven repository
exit /b -1s

:end
