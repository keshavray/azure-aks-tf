resource "azurerm_storage_account" "storage_account" {
  name                     = join("", [var.product, "apptfstatestr1", var.location, var.environment])
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storagetier
  account_replication_type = var.storage_replication

  tags = local.tags
}
resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}