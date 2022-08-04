resource "azurerm_iothub" "iothub" {
  name                = join("-", [var.product, var.role, "hub", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "S1"
    capacity = "1"
  }


  endpoint {
    type              = "AzureIotHub.ServiceBusQueue"
    connection_string = azurerm_servicebus_queue_authorization_rule.send.primary_connection_string
    name              = "exportsb"
  }

  route {
    name           = "exportsb"
    source         = "DeviceMessages"
    condition      = "true"
    endpoint_names = ["exportsb"]
    enabled        = true
  }


  tags = local.tags
}