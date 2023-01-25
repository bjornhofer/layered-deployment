locals {
    projectdetails = yamldecode(file(find_in_parent_folders("project.yml")))
    layer_settings = try(yamldecode(file("settings.yml")), null)
    sources = yamldecode(file(find_in_parent_folders("sources.yml")))
}

dependency "subscription" {
    config_path = "${local.projectdetails.root_folder}/layer0/subscription"
}

generate "backend" {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    terraform {
        backend "azurerm" {
            resource_group_name  = "statefiles"
            storage_account_name = "${local.projectdetails.name}statefile"
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
        subscription_id = "${try(local.projectdetails.subscription_id, dependency.subscription.outputs.subscription.subscription_id)}"
    }
EOF
}