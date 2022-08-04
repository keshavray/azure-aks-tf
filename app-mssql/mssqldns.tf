resource "azurerm_private_dns_zone" "private_mssql_dns" {
  name                = "privatelink.sql.database.azure.com"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}
resource "azurerm_private_dns_zone_virtual_network_link" "mssql_vnet_link" {
  name                  = join("-", [var.product, var.role, "vnet-link", var.location, var.environment])
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_mssql_dns.name
  virtual_network_id    = data.terraform_remote_state.platform.outputs.vnet_id
  tags                  = local.tags
}
