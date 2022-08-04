resource "azurerm_storage_account" "storage_account" {
  name                     = join("", [var.product, "str1", var.app_name, var.location, var.environment])
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = var.storagetier
  account_replication_type = var.storage_replication

  tags = var.tags
}

resource "azurerm_app_service_plan" "function_app_plan" {
  name                         = join("-", [var.product, "appsp-1", var.app_name, var.location, var.environment])
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  kind                         = var.kind
  reserved                     = var.reserved
  maximum_elastic_worker_count = var.worker_count
  sku {
    tier = var.sku_tier
    size = var.sku_size
  }

  tags = var.tags
}

resource "azurerm_function_app" "function_app" {
  name                       = join("-", [var.product, var.role, var.app_name, var.location, var.environment])
  resource_group_name        = azurerm_resource_group.rg.name
  location                   = azurerm_resource_group.rg.location
  app_service_plan_id        = azurerm_app_service_plan.function_app_plan.id
  storage_account_name       = azurerm_storage_account.storage_account.name
  storage_account_access_key = azurerm_storage_account.storage_account.primary_access_key

  version                 = var.app_version
  https_only              = var.https_only
  client_affinity_enabled = var.client_affinity_enabled

  site_config {
    always_on        = var.always_on
    #linux_fx_version = var.linux_fx_version
    min_tls_version  = var.min_tls_version
  }
  os_type      = var.os_type
  #app_settings = var.app_settings

  tags = var.tags
}