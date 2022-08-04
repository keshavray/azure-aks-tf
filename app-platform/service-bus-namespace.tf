resource "azurerm_servicebus_namespace" "app_sb_namespace" {
  name                = join("-", [var.product, var.role, "app-svbnsp", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  capacity            = 0
  tags                = local.tags

}