
data "azurerm_subscription" "current" {}

#Used by key-vault.tf
data "terraform_remote_state" "loga" {
  backend = "azurerm"
  config = {
    key                  = "log-analytics.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["hubtfstr", var.location, "prd"])
    resource_group_name  = join("-", ["hub-tf-state-rg", var.location, "prd"])
    access_key           = var.tfstate_access_key
  }
}
