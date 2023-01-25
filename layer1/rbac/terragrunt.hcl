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
            container_name       = "layer1"
            key                  = "rbac.tfstate"
        }
    }
    EOF
}

dependency management_group {
  config_path = "${include.root.locals.projectdetails.root_folder}/layer1/management_group"
}

dependencies {
    paths = ["${include.root.locals.projectdetails.root_folder}/layer1/management_group"]
}

terraform {
  source = include.root.locals.sources["rbac"]
}

inputs = {
    base_name = include.root.locals.projectdetails.name
    assign_id = dependency.management_group.outputs.management_group[0].id
}