output "aks-subnet-id" {
  description = "aks-subnet-id"
  value       = azurerm_subnet.subnet.id
}


output "aks-identities" {
  description = "aks identities"
  value       = azurerm_kubernetes_cluster.k8s.identity
}

output "aks-name" {
  description = "aks cluster name"
  value       = azurerm_kubernetes_cluster.k8s.name
}

output "aks-rg" {
  description = "aks cluster RG"
  value       = azurerm_kubernetes_cluster.k8s.resource_group_name
}

/*
output "aad_pod_identity_clientid" {
  description = "aad_pod_identity_clientid"
  value       = azurerm_user_assigned_identity.aad_pod_identity.client_id
}

output "aad_pod_identity_id" {
  description = "aad_pod_identity_id"
  value       = azurerm_user_assigned_identity.aad_pod_identity.id
}

 output "dns_" {
  description = "aad_pod_identity_id"
  value       = azurerm_private_endpoint.containter_Registry_Connection.private_dns_zone_configs
}
 */

output "identity_resource_id" {
  value = azurerm_user_assigned_identity.appgwIdentity.id
}

output "identity_client_id" {
  value = azurerm_user_assigned_identity.appgwIdentity.client_id
}