/*data "azurerm_resource_group" "servicebus-rg" {
  name = join("-", [var.product, "svl-rg", var.location, var.environment])
}*/

#clinical platform NOT hub platform
data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    key                  = "app-platform.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["cptfstr1", var.location, var.environment])
    resource_group_name  = join("-", ["cp-tf-state-rg", var.location, var.environment])
  }
}
#Used by aks.tf and key-vault.tf
data "terraform_remote_state" "loga" {
  backend = "azurerm"
  config = {
    key                  = "log-analytics.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["hubtfstr1", var.location, "prd"])
    resource_group_name  = join("-", ["hub-tf-state-rg", var.location, "prd"])
    access_key           = var.tfstate_access_key
  }
}

data "terraform_remote_state" "creg" {
  backend = "azurerm"
  config = {
    key                  = "container-registry.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["hubtfstr1", var.location, "prd"])
    resource_group_name  = join("-", ["hub-tf-state-rg", var.location, "prd"])
    access_key           = var.tfstate_access_key
  }
}
/*
data "terraform_remote_state" "azdo-agent" {
  backend = "azurerm"
  config = {
  }
}
*/
data "terraform_remote_state" "hub-platform" {
  backend = "azurerm"
  config = {
    key                  = "platform.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["hubtfstr1", var.location, "prd"])
    resource_group_name  = join("-", ["hub-tf-state-rg", var.location, "prd"])
    access_key           = var.tfstate_access_key
  }
}