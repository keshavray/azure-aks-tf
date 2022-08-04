module "quest-function" {

  source = ".//modules//az-function"

  product                 = var.product
  squad                   = var.squad
  environment             = var.environment
  role                    = var.role
  description             = var.description
  app_name                = "quest"
  tags                    = local.tags
  resource_group_location = var.resource_group_location
  location                = var.location

  storagetier         = "Standard"
  storage_replication = "LRS"

  kind         = "elastic"
  reserved     = true
  worker_count = 1
  sku_tier     = "ElasticPremium"
  sku_size     = "EP1"

  #############################
  # Function App Service Plan #
  #############################
  app_version             = "~3"
  https_only              = false
  client_affinity_enabled = false
  always_on               = false
  min_tls_version         = "1.2"
  os_type                 = "linux"

}