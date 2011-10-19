maintainer        "Nathan Jones"
maintainer_email  "thenathanjones@gmail.com"
license           "Apache 2.0"
description       "Installs and configures the JDK"
version           "0.0.1"

recipe "java", "Installs Go Server and Agent"
recipe "go::jdk", "Installs Oracle/Sun JDK"
recipe "go::openjdk", "Installs OpenJDK"

%w{ ubuntu debian centos redhat fedora }.each do |os|
  supports os
end