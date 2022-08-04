resource "azurerm_application_gateway" "aks_appgw" {
  name                = join("-", [var.product, var.role, "appgw", var.location, var.environment])
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = var.app_gateway_sku
    tier     = var.app_gateway_tier
    capacity = 2
  }

  gateway_ip_configuration {
    name      = "appGatewayIpConfig"
    subnet_id = azurerm_subnet.appgwsubnet.id
  }

  frontend_port {
    name = local.frontend_port_name
    port = 80
  }

  frontend_port {
    name = local.https_frontend_port_name
    port = 443
  }

  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.appgw.id
  }

  backend_address_pool {
    name = local.backend_address_pool_name
  }

  backend_http_settings {
    name                  = local.http_setting_name
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 1
  }

  http_listener {
    name                           = local.listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.frontend_port_name
    protocol                       = "Http"
  }
/*   
   http_listener {
    name                           = local.https_listener_name
    frontend_ip_configuration_name = local.frontend_ip_configuration_name
    frontend_port_name             = local.https_frontend_port_name
    protocol                       = "Https"
    ssl_certificate_name           = local.AppGWCertName
  } 
 */
  request_routing_rule {
    name                       = local.request_routing_rule_name
    rule_type                  = "Basic"
    http_listener_name         = local.listener_name
    backend_address_pool_name  = local.backend_address_pool_name
    backend_http_settings_name = local.http_setting_name
  }

  ssl_certificate {
    name                = local.AppGWCertName
    key_vault_secret_id = local.AppGWCert
  }
  #Set the latest policy and enforces TLS 1.2
  ssl_policy {
    policy_type = "Predefined"
    policy_name = "AppGwSslPolicy20170401S"
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [data.terraform_remote_state.hub-platform.outputs.vault_identity]
  } 
 
#We ignore this as we have to add the VMSS manually 
   lifecycle {
    ignore_changes = [frontend_port, backend_address_pool, backend_http_settings, http_listener, request_routing_rule, probe, url_path_map, tags]
  } 
  tags = local.tags

  depends_on = [azurerm_public_ip.appgw]
}