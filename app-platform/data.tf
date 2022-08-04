data "azurerm_client_config" "current" {
}


/* data "azurerm_subnet" "hub-azdo-subnet" {
  name                 = join("-", ["hub-azdo-sn", var.location, var.environment])
  virtual_network_name = join("-", ["hub-pfm-vnet", var.location, var.environment])
  resource_group_name  = join("-", ["hub-pfm-rg", var.location, var.environment])
}
 */
data "terraform_remote_state" "hub-azdo-subnet" {
  backend = "azurerm"
  config = {
    key                  = "azure-devops.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["hubtfstr1", var.location, "prd"])
    resource_group_name  = join("-", ["hub-tf-state-rg", var.location, "prd"])
    access_key           = var.tfstate_access_key
  }
}


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
