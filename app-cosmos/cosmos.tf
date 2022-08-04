resource "azurerm_cosmosdb_account" "cosdb-db" {
  name                = join("-", [var.product, var.role, var.location, var.environment])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  offer_type          = "Standard"
  kind                = var.cosmos-server.kind

  tags = local.tags

  consistency_policy {
    consistency_level = "Session"
  }


  geo_location {
    prefix            = join("-", [var.product, var.role, var.location, var.environment])
    location          = azurerm_resource_group.rg.location
    failover_priority = 0
  }

}

resource "azurerm_private_endpoint" "COSMOS_Connection" {
  name                = join("-", [var.product, var.role, "pep", var.location, var.environment])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "cosmos-1-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosdb-db.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "privatelink-cosmos-1-database-azure-com"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_cosmos_dns.id]
  }
  tags = local.tags
}
