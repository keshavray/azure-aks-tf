

resource "azurerm_key_vault" "keyvault" {
  name                            = join("-", [var.product, var.role, "kv", var.location, var.environment])
  location                        = var.resource_group_location
  resource_group_name             = azurerm_resource_group.rg.name
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  tenant_id                       = data.azurerm_subscription.current.tenant_id
  soft_delete_enabled             = true
  purge_protection_enabled        = true

  sku_name = var.sku_name

  network_acls {
    default_action = var.default_action
    bypass         = var.bypass
    ip_rules = [
      "82.26.86.238/32",
    ]
    #list of subnets allowed to access the Keyvault, if running via a pipeline you need to give access to the agent VM
    #Add the subnet the Agent is part of to this list
    #virtual_network_subnet_ids = ["/subscriptions/%SUBSCRIPTION%/resourceGroups/%RG%/providers/Microsoft.Network/virtualNetworks/%VNET%/subnets/%SUBNET%"]
  }

  tags = local.tags
}

resource "azurerm_monitor_diagnostic_setting" "diag" {
  name                       = join("-", [var.product, var.role, "diag-kv", var.location, var.environment])
  target_resource_id         = azurerm_key_vault.keyvault.id
  log_analytics_workspace_id = data.terraform_remote_state.loga.outputs.log_analytics_resource_id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      enabled = true
    }
  }
}