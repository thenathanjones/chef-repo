name "appserver"
description "ruby app server"

#placeholder role
run_list "role[appserver]"

# Attributes applied if the node doesn't have it set already.
default_attributes()

# Attributes applied no matter what the node has set already.
override_attributes()