
SET PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;C:\opscode\chef\bin;C:\Program Files (x86)\Git\cmd

IF NOT EXIST C:\opscode\chef\bin\chef-solo.bat msiexec /qb /i chef-client-latest.msi

call C:\opscode\chef\embedded\bin\gem.bat install minitest-chef-handler

mkdir C:\tools
mkdir C:\tools\chef
mkdir C:\tools\chef\cache
mkdir C:\tools\chef\backup
mkdir C:\tools\chef\roles

call chef-solo -c %CD%\Chef\solo.rb

pause