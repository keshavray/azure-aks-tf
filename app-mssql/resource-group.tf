resource "azurerm_resource_group" "rg" {
  name     = join("-", [var.product, var.role, "rg", var.location, var.environment])
  location = var.resource_group_location
  tags     = local.tags
}

# resource "azurerm_management_lock" "resource-group-level" {
#   name       = join("-", [azurerm_resource_group.rg.name, "rg-lock", ])
#   scope      = azurerm_resource_group.rg.id
#   lock_level = "CanNotDelete"
#   notes      = "Items can't be deleted in this Resource Group!"
# }