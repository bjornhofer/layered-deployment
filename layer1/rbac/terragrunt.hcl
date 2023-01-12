include "root" {
  path = find_in_parent_folders()
  expose = true
}

dependency management_group {
  config_path = "/home/azureuser/terragrunt/layer1/management_group"
}

dependencies 

terraform {
    source = "github.com/bjornhofer/terraform_rbac.git"
}

inputs = {
    base_name = include.root.locals.projectdetails.name
    assign_id = dependency.management_group.outputs.management_group[0].id
}