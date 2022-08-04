# User Assigned Identities for Application Gateway Ingress controller
resource "azurerm_user_assigned_identity" "appgwIdentity" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.resource_group_location

  name = join("-", [var.product, "appgw-aad-pod-uaid", var.location, var.environment])

  tags = local.tags
}

resource "azurerm_role_assignment" "appgw-contributor-role" {
  scope                = azurerm_application_gateway.aks_appgw.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.appgwIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.appgwIdentity, azurerm_application_gateway.aks_appgw]
}

resource "azurerm_role_assignment" "appgw-reader-role" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.appgwIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.appgwIdentity, azurerm_application_gateway.aks_appgw]
}

resource "azurerm_role_assignment" "appgw_managed_id_role" {
  scope                = azurerm_user_assigned_identity.appgwIdentity.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_kubernetes_cluster.k8s.kubelet_identity[0].object_id
  depends_on           = [data.azurerm_resource_group.k8s-rg]
}
#permissions for Appgw to access keyvault in hub
resource "azurerm_role_assignment" "keyvault-operator-role" {
  scope                = data.terraform_remote_state.hub-platform.outputs.vault_identity
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.appgwIdentity.principal_id
  depends_on           = [azurerm_user_assigned_identity.appgwIdentity, azurerm_application_gateway.aks_appgw]
}
