include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = include.root.locals.sources["resource_group"]
}

inputs = {
    resource_group_name = "${include.root.locals.projectdetails.name}-vnet"
    resource_group_location = try(include.root.locals.layer_settings.vnet_location, try(include.root.locals.layer_settings.location, include.root.locals.projectdetails.location))
    resource_group_role_assignments = try(include.root.locals.layer_settings.vnet_rbac, try(include.root.locals.layer_settings.vnet_location, {}))
    resource_group_create = try(include.root.locals.layer_settings.dbg_simulate, try(include.root.locals.projectdetails.dbg_simulate, false))
}