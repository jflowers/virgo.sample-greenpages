@echo off
call set.env.cmd
cd "C:\Program Files\springsource\sts-2.9.2.RELEASE"
STS -clean -data %CD% -vm %JAVA_HOME%\bin\javaw.exe -vmargs -Dsun.lang.ClassLoader.allowArraySyntax=true -Xmx1024m -Xms128m 