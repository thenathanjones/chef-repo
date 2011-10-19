maintainer        "Nathan Jones"
maintainer_email  "thenathanjones@gmail.com"
license           "Apache 2.0"
description       "Installs and configures Go Server and local agent"
version           "0.0.1"

recipe "go", "Installs Go Server and Agent"
recipe "go::server", "Installs Go Server"
recipe "go::agent", "Installs Go Agent"

%w{ ubuntu debian centos redhat fedora }.each do |os|
  supports os
end

%w{ java }.each do |cb|
  depends cb
end