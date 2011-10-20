maintainer        "Nathan Jones"
maintainer_email  "thenathanjones@gmail.com"
license           "Apache 2.0"
description       "Installs and configures SQLite in a consistent way"
version           "0.0.1"

recipe "sqlite", "Installs SQLite from source"

%w{ ubuntu debian centos redhat fedora }.each do |os|
  supports os
end