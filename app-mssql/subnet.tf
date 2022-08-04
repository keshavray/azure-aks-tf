resource "azurerm_subnet" "subnet" {
  name                                           = join("-", [var.product, var.role, "sn", var.location, var.environment])
  resource_group_name                            = data.terraform_remote_state.platform.outputs.resource_group
  virtual_network_name                           = data.terraform_remote_state.platform.outputs.vnet
  address_prefixes                               = [var.subnet_cidr]
  service_endpoints                              = var.service_endpoints
  enforce_private_link_endpoint_network_policies = true
}

resource "azurerm_subnet_network_security_group_association" "network_security_group_associations" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
