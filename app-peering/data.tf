data "terraform_remote_state" "spoke-platform" {
  backend = "azurerm"
  config = {
    key                  = "app-platform.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["cptfstr1", var.location, var.environment])
    resource_group_name  = join("-", ["cp-tf-state-rg", var.location, var.environment])
  }
}


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

/* data "terraform_remote_state" "privatedns" {
  backend = "azurerm"
  config = {
    key                  = "privatedns.terraform.tfstate"
    container_name       = "tfstate"
    storage_account_name = "hubtfstr#{LOC}##{ENV}#"
    resource_group_name  = "hub-tf-state-rg-#{LOC}##{ENV}#"
    access_key           = var.tfstate_access_key
  }
}
 */


