include "root" {
  path = find_in_parent_folders()
  expose = true
}

dependency vnet_resource_group {
  config_path = "${include.root.locals.projectdetails.root_folder}/layer2/vnet_resource_group"
}

dependencies {
    paths = ["${include.root.locals.projectdetails.root_folder}/layer2/vnet_resource_group"]
}

terraform {
  source = include.root.locals.sources["vnet"]
}

inputs = {
    vnet_ressource_group_name = dependency.vnet_resource_group.outputs.ressource_group.id
}