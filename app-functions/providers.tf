terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.45.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Needed when adding rules to allow function to read from service bus
# data "azurerm_servicebus_namespace_authorization_rule" "functions_read" {
#   name                = "FUNCTIONS_READ"
#   namespace_name      = "cp-svl-svbnsp-#{LOC}#-#{ENV}#"
#   resource_group_name = "cp-svl-rg-#{LOC}#-#{ENV}#"
# }
