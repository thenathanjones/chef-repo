maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs Ruby and related packages"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.9.0"

recipe "default", "Installs Ruby and related packages"
recipe "1.8.7", "Installs Ruby 1.8.7 and related packages"
recipe "1.9.1", "Installs Ruby 1.9.1 and related packages"
recipe "1.9.2", "Installs Ruby 1.9.2 and related packages"