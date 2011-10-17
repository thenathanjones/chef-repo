name "dbserver"
description "mysql db server"

#placeholder role
run_list "recipe[mysql::server]"

# Attributes applied if the node doesn't have it set already.
default_attributes()

# Attributes applied no matter what the node has set already.
override_attributes()