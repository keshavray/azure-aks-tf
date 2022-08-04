locals {
  tfstate           = join("", [var.role, ".tfstate"])
  tfstate_store     = join("", [var.product, "tfstr",var.location, var.environment])
}

locals {
  tags = {
    product     = var.product
    environment = var.environment
    squad       = var.squad
    description = var.description
    tfstate     = "https://${local.tfstate_store}.blob.core.windows.net/tfstate/${local.tfstate}"
  }
  backend_address_pool_name      = join("-", [var.product, var.role, "beap", var.location, var.environment])
  frontend_port_name             = join("-", [var.product, var.role, "fepn", var.location, var.environment])
  frontend_ip_configuration_name = join("-", [var.product, var.role, "feip", var.location, var.environment])
  http_setting_name              = join("-", [var.product, var.role, "behttp", var.location, var.environment])
  listener_name                  = join("-", [var.product, var.role, "httplist", var.location, var.environment])
  https_listener_name            = join("-", [var.product, var.role, "httpslist", var.location, var.environment])
  https_frontend_port_name       = join("-", [var.product, var.role, "httpsfepn", var.location, var.environment])
  request_routing_rule_name      = join("-", [var.product, var.role, "rert", var.location, var.environment])
  probe_name                     = join("-", [var.product, var.role, "root-probe", var.location, var.environment])
  AppGWCert  = "https://hub-pfm-1-kv-eaus-prd.vault.azure.net/secrets/rey-health-ssl135297c4-fd67-4017-8152-227ef88e523b"
  AppGWCertName = "reyhealth"
}
