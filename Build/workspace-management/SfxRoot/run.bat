
SET PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;C:\opscode\chef\bin;C:\Program Files (x86)\Git\cmd

IF NOT EXIST C:\opscode\chef\bin\chef-solo.bat msiexec /qb /i chef-client-latest.msi

call chef-solo -c %CD%\Chef\solo.rb

pause