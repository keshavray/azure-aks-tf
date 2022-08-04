resource "azurerm_sql_server" "mssql" {
  name                         = join("-", [var.product, var.role, var.location, var.environment])
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = var.mssql-version
  administrator_login          = data.azurerm_key_vault_secret.cp-mssql-eaus-prd-USERNAME.value
  administrator_login_password = data.azurerm_key_vault_secret.cp-mssql-eaus-prd-PASSWORD.value
  tags = local.tags

  lifecycle {
    ignore_changes = [
      identity
    ]
  }

}

resource "azurerm_private_endpoint" "MSSQL_Connection" {
  name                = join("-", [var.product, var.role, "pep", var.location, var.environment])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "mssql-1-connection"
    private_connection_resource_id = azurerm_sql_server.mssql.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "privatelink-mssql-1-database-azure-com"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_mssql_dns.id]
  }
  tags = local.tags
}

resource "azurerm_sql_active_directory_administrator" "mssql_AD_Admin" {
  server_name         = azurerm_sql_server.mssql.name
  resource_group_name = azurerm_resource_group.rg.name
  login               = "ovr_admin"
  tenant_id           = "1b9a0349-39d1-4f9d-87ff-055c9b7d14c4"
  #AD Group `CP-MSSQL-Admin`
  object_id           = "19597d6a-446c-4e5d-9632-ac793900d4bb"
}

