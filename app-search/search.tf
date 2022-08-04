resource "azurerm_search_service" "az-search" {
  name                = join("-", [var.product, var.role, var.location, var.environment])
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  sku                 = var.sku
}