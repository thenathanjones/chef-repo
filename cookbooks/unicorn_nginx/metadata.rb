maintainer        "Nathan Jones"
maintainer_email  "thenathanjones@gmail.com"
license           "Apache 2.0"
description       "Installs and configures nginx and unicorn"
version           "0.0.1"

recipe "unicorn_nginx", "Installs nginx and unicorn packages and sets up configuration"

%w{ ubuntu debian centos redhat fedora }.each do |os|
  supports os
end

%w{ nginx unicorn }.each do |cb|
  depends cb
end