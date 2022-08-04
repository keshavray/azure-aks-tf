resource "azurerm_virtual_network" "vnet" {
  name                = join("-", [var.product, var.role, "vnet", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet_cidr
  location            = var.resource_group_location
  dns_servers         = var.vnet_dns_servers

  tags = local.tags
}