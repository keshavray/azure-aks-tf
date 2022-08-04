
resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                = join("-", [var.product, var.role, "svbnsp", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  capacity            = 0
  tags                = local.tags

}

resource "azurerm_servicebus_queue" "sb_queue" {
  name                = join("-", [var.product, var.role, "queue", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name

  enable_partitioning = true
}

resource "azurerm_servicebus_queue_authorization_rule" "send" {
  name                = "sendrule"
  namespace_name      = azurerm_servicebus_namespace.sb_namespace.name
  queue_name          = azurerm_servicebus_queue.sb_queue.name
  resource_group_name = azurerm_resource_group.rg.name

  listen = true
  send   = true
  manage = false
}