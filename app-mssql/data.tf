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

data "azurerm_key_vault" "keyvault" {
  name                = join("-", ["cp-pfm-1-kv", var.location, var.environment])
  resource_group_name = join("-", ["cp-pfm-1-rg", var.location, var.environment])
}

data "azurerm_key_vault_secret" "cp-mssql-eaus-prd-PASSWORD" {
  name         = join("-", ["cp-mssql", var.location, var.environment, "PASSWORD"])
  key_vault_id = data.azurerm_key_vault.keyvault.id
}

data "azurerm_key_vault_secret" "cp-mssql-eaus-prd-USERNAME" {
  name         = join("-", ["cp-mssql", var.location, var.environment, "USERNAME"])
  key_vault_id = data.azurerm_key_vault.keyvault.id
}