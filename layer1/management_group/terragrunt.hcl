include "root" {
  path = find_in_parent_folders()
  expose = true
}

locals {
    root_management_group = "mg-root"
}

dependency "layer0" {
    config_path = "/home/azureuser/terragrunt/layer0"
}


terraform {
    source = "github.com/bjornhofer/terraform_management_group.git"
}

inputs = {
    mgmt_group_parent = try(include.root.locals.projectdetails.mgmt_group_parent, local.root_management_group)
    management_group_name = try(include.root.locals.projectdetails.dbg_simulate, false) == false ? "${include.root.locals.projectdetails.name}" : local.root_management_group
    management_group_subscriptions = ["${dependency.layer0.outputs.subscription.subscription_id}"]
    dbg_simulate = try(include.root.locals.projectdetails.dbg_simulate, false)
    base_name = include.root.locals.projectdetails.name
}