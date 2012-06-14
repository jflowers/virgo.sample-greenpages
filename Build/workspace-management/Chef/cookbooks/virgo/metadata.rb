maintainer       "agilex"
maintainer_email "jay.flowers@gmail.com"
license          "All rights reserved"
description      "Installs/Configures virgo"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ windows }.each do |os|
  supports os
end

depends "windows"