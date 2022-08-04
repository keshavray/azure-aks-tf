data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    key                  = "app-platform.tfstate"
    container_name       = "tfstate"
    storage_account_name = join("", ["cptfstr", var.location, var.environment])
    resource_group_name  = join("-", ["cp-tf-state-rg", var.location, var.environment])
  }
}