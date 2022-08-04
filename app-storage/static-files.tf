resource "azurerm_storage_account" "static-files" {
  name                      = join("", [var.product, var.role, "static", var.location, var.environment])
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  account_tier              = var.storagetier
  account_replication_type  = var.storage_replication
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  allow_blob_public_access  = true
  enable_https_traffic_only = true

  #custom_domain {
  #name =  var.filecustomdomain
  #use_subdomain = true
  #}

  tags = local.tags
}
resource "azurerm_storage_container" "static" {
  name                  = "static"
  storage_account_name  = azurerm_storage_account.static-files.name
  container_access_type = "private"
}


