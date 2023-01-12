include "root" {
  path = find_in_parent_folders()
  expose = true
}

dependency management_group {
  config_path = "/home/azureuser/terragrunt/layer1/management_group"
}

dependencies {
    paths = ["/home/azureuser/terragrunt/layer1/management_group"]
}

terraform {
  source = include.root.locals.sources["rbac"]
}

inputs = {
    base_name = include.root.locals.projectdetails.name
    assign_id = dependency.management_group.outputs.management_group[0].id
}