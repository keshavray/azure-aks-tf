resource "azurerm_resource_group" "rg" {
  name     = join("-", [var.product, var.role, "rg", var.location, var.environment])
  location = var.resource_group_location

  tags = local.tags
}