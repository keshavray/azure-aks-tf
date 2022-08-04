resource "azurerm_subnet" "subnet" {
  name                 = join("-", [var.product, var.role, "sn", var.location, var.environment])
  resource_group_name  = data.terraform_remote_state.platform.outputs.resource_group
  virtual_network_name = data.terraform_remote_state.platform.outputs.vnet
  address_prefixes     = var.subnet_cidr
  service_endpoints    = var.service_endpoints

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_associations" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet" "appgwsubnet" {
  name                 = join("-", [var.product, var.role, "appgw", "sn", var.location, var.environment])
  resource_group_name  = data.terraform_remote_state.platform.outputs.resource_group
  virtual_network_name = data.terraform_remote_state.platform.outputs.vnet
  address_prefixes     = var.appgw_subnet_cidr
  service_endpoints    = var.appgw_service_endpoints

  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_public_ip" "appgw" {
  name                = join("-", [var.product, var.role, "appgw", "pip", var.location, var.environment])
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = join("-", [var.product, var.role, "appgw", "pip", var.location, var.environment])

  tags = local.tags
}

resource "azurerm_subnet_network_security_group_association" "appgw_network_security_group_associations" {
  subnet_id                 = azurerm_subnet.appgwsubnet.id
  network_security_group_id = azurerm_network_security_group.appgwnsg.id
}



resource "azurerm_private_endpoint" "containter_Registry_Connection" {
  name                = join("-", [var.product, var.role, "creg-pep", var.location, var.environment])
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.subnet.id

  private_service_connection {
    name                           = "creg-connection"
    private_connection_resource_id = data.terraform_remote_state.creg.outputs.creg_id
    subresource_names              = ["registry"]
    is_manual_connection           = false
  }
  private_dns_zone_group {
    name                 = "privatelink-azurecr-io"
    private_dns_zone_ids = [azurerm_private_dns_zone.private_dns.id]
  }
  tags = local.tags
}

resource "azurerm_private_dns_zone" "private_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = join("-", [var.product, var.role, "vnet_link", var.location, var.environment])
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.private_dns.name
  virtual_network_id    = data.terraform_remote_state.platform.outputs.vnet_id
  tags                  = local.tags
} 