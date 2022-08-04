output "vnet" {
  description = "VNET resource"
  value       = azurerm_virtual_network.vnet.name
}
output "vnet_id" {
  description = "VNET ID"
  value       = azurerm_virtual_network.vnet.id
}
output "resource_group" {
  description = "Resource group for VNET"
  value       = azurerm_resource_group.rg.name
  depends_on = [
    azurerm_resource_group.rg
  ]
}

output "kv_id" {
  description = "Key Vault ID"
  value       = azurerm_key_vault.keyvault.id
}


