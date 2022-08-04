resource "azurerm_network_security_group" "nsg" {
  name                = join("-", [var.product, var.role, "nsg", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location

  security_rule {
    name                       = "inbound-aks"
    description                = "Allow inbound ports for SQL from AKS"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_ranges    = ["1433-1434"]
    source_address_prefix      = "10.1.128.0/21"
    destination_address_prefix = "10.1.0.4"
  }

  tags = local.tags
}

