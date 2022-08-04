resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = join("-", ["hub-to", var.product, var.location, var.environment])
  resource_group_name          = data.terraform_remote_state.hub-platform.outputs.resource_group
  virtual_network_name         = data.terraform_remote_state.hub-platform.outputs.vnet
  remote_virtual_network_id    = data.terraform_remote_state.spoke-platform.outputs.vnet_id
  allow_virtual_network_access = true
  allow_gateway_transit        = true
  provider                     = azurerm.hub
}
resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = join("-", [var.product, var.location, var.environment, "to-hub", ])
  resource_group_name          = data.terraform_remote_state.spoke-platform.outputs.resource_group
  virtual_network_name         = data.terraform_remote_state.spoke-platform.outputs.vnet
  remote_virtual_network_id    = data.terraform_remote_state.hub-platform.outputs.vnet_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  #use_remote_gateways          = true # Throws Error: 'cannot have UseRemoteGateway flag set to true because remote virtual network referenced by the peering does not have any gateways'
  provider                     = azurerm.spoke

  depends_on = [azurerm_virtual_network_peering.hub-to-spoke]
}
 
 