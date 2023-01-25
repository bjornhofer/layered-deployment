include "root" {
  path = find_in_parent_folders()
  expose = true
}

generate "backend" {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    terraform {
        backend "azurerm" {
            resource_group_name  = "statefiles"
            storage_account_name = "${include.root.locals.projectdetails.name}statefile"
            container_name       = "layer2"
            key                  = "vnet_peering.tfstate"
        }
    }
    EOF
}

dependency vnet_resource_group {
  config_path = "${include.root.locals.projectdetails.root_folder}/layer2/vnet_resource_group"
}

dependency vnet {
    config_path = "${include.root.locals.projectdetails.root_folder}/layer2/vnet"
}

dependencies {
    paths = ["${include.root.locals.projectdetails.root_folder}/layer2/vnet_resource_group", "${include.root.locals.projectdetails.root_folder}/layer2/vnet"]
}

terraform {
  source = include.root.locals.sources["vnet_peering"]
}

inputs = {
    vnet_peering_source_vnet = dependency.vnet.outputs.vnet.id
    vnet_peering_destination_vnet = include.root.locals.projectdetails.peering_vnet_id
    vnet_peering_resource_group = dependency.vnet_resource_group.outputs.resource_group[0].name
}