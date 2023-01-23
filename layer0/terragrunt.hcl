locals {
    projectdetails = yamldecode(file(find_in_parent_folders("project.yml")))
    layer_settings = try(yamldecode(file("settings.yml")), null)
    sources = yamldecode(file(find_in_parent_folders("sources.yml")))
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    provider "azurerm" {
        features {}
        subscription_id = "${local.projectdetails.default_subscription_id}"
    }
EOF
}

generate "backend" {
    path = "backend.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
    terraform {
        backend "azurerm" {
            resource_group_name  = "statefiles"
            storage_account_name = "${local.projectdetails.name}statefile"
            container_name       = "layer0"
            key                  = "terraform.tfstate"
        }
    }
    EOF
}