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
            key                  = "vnet.tfstate"
        }
    }
    EOF
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
    vnet_resource_group_name = dependency.vnet_resource_group.outputs.resource_group[0].name
    vnet_name = "${include.root.locals.projectdetails.name}-net01"
    vnet_location = dependency.vnet_resource_group.outputs.resource_group[0].location
    vnet_address_space = include.root.locals.projectdetails.vnet_adress_space
    vnet_subnet_details = try(include.root.locals.projectdetails.vnet_subnet_details, null)
}