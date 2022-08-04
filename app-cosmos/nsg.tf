resource "azurerm_network_security_group" "nsg" {
  name                = join("-", [var.product, var.role, "nsg", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location

  tags = local.tags
}

