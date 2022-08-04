data "azurerm_subscription" "current" {}

/* resource "azurerm_private_endpoint" "vault_connection" {
  name                = join("-", [var.product, var.role, "vault-pep", var.location, var.environment])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.hub-azdo-subnet.id

  private_service_connection {
    name                           = "vault-connection"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }
  tags = local.tags

} */
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
    #list of subnets allowed to access the Keyvault, if running via a pipeline you need to give access to the agent VM
    #Add the subnet the Agent is part of to this list
    #virtual_network_subnet_ids = ["/subscriptions/%SUBSCRIPTION%/resourceGroups/%RG%/providers/Microsoft.Network/virtualNetworks/%VNET%/subnets/%SUBNET%"]
    virtual_network_subnet_ids = [data.terraform_remote_state.hub-azdo-subnet.outputs.azdo_subnet_id]
    ip_rules = [
      "51.104.26.0/24",
    ]
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



resource "azurerm_key_vault_access_policy" "azures_devops_vault_ap" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id
  key_permissions = []
  secret_permissions = [
    "get",
    "list"
  ]
  storage_permissions = []
  certificate_permissions = []

  depends_on = [
    azurerm_key_vault.keyvault
  ]
}

resource "azurerm_key_vault_access_policy" "azures_devops_sql_admin_vault_ap" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_subscription.current.tenant_id
  #AD Group `CP-MSSQL-Admin`
  object_id    = "19597d6a-446c-4e5d-9632-ac793900d4bb"
  key_permissions = []
  secret_permissions = [
    "get",
    "list"
  ]
  storage_permissions = []
  certificate_permissions = []

  depends_on = [
    azurerm_key_vault.keyvault
  ]
}
