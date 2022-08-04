resource "azurerm_network_security_group" "appgwnsg" {
  name                = join("-", [var.product, var.role, "appgw-nsg", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location

  security_rule {
    name                       = "inbound-app-gateway"
    description                = "Allow inbound health probe ports for AppGW"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["65200-65535"]
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "inbound-web-front-door"
    description                = "Allow inbound web ports from azure Front Door"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["80", "443"]
    source_address_prefix      = "AzureFrontDoor.Backend"
    destination_address_prefix = "*"
  }
  tags = local.tags
}

