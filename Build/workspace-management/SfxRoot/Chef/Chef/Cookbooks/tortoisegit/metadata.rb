maintainer       "Agilex"
maintainer_email "jay.flowers@agilex.com"
license          "All rights reserved"
description      "Installs/Configures tortoisegit"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ windows }.each do |os|
  supports os
end

depends "windows"