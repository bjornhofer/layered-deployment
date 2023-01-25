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
            key                  = "management_groups.tfstate"
        }
    }
    EOF
}

locals {
    root_management_group = "mg-root"
}

dependency "subscription" {
    config_path = "${include.root.locals.projectdetails.root_folder}/layer0/subscription"
}

terraform {
    source = include.root.locals.sources["management_group"]
}

inputs = {
    mgmt_group_parent = try(include.root.locals.projectdetails.mgmt_group_parent, local.root_management_group)
    management_group_name = try(include.root.locals.projectdetails.dbg_simulate, false) == false ? "${include.root.locals.projectdetails.name}" : local.root_management_group
    management_group_subscriptions = ["${dependency.subscription.outputs.subscription.subscription_id}"]
    dbg_simulate = try(include.root.locals.layer_settings.dbg_simulate, try(include.root.locals.projectdetails.dbg_simulate, false))
    base_name = include.root.locals.projectdetails.name
}