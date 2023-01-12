locals {
    projectdetails = yamldecode(file(find_in_parent_folders("project.yml")))
    layer_settings = try(yamldecode(file("settings.yml")), null)
    
}

dependency "layer0" {
    config_path = "/home/azureuser/terragrunt/layer0"
}

generate "backend" {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    terraform {
        backend "azurerm" {
            resource_group_name  = "salzburgagstate"
            storage_account_name = "${local.projectdetails.name}sagstate"
            container_name       = "layer1"
            key                  = "terraform.tfstate"
        }
    }
    EOF
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "azurerm" {
        features {}
        subscription_id = "${dependency.layer0.outputs.subscription.subscription_id}"
    }
EOF
}