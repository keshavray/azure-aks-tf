resource "azurerm_resource_group" "rg" {
  name     = join("-", [var.product, var.role, var.app_name, "rg", var.location, var.environment])
  location = var.resource_group_location

  tags = var.tags
}

