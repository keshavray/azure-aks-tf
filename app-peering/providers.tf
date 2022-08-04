terraform {
  backend "azurerm" {}
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.49.0"
    }
  }
}

provider "azurerm" {
  version = "=2.49.0"
  alias    = "spoke"
  features {}
}

provider "azurerm" {
   version = "=2.49.0"
  features {}
  tenant_id       = var.hub_tenant_id
  subscription_id = var.hub_subscription_id
  client_id       = var.hub_client_id
  client_secret   = var.hub_client_secret
  alias           = "hub"
}
/* provider "azurerm" {
  version = "=2.20.0"
  features {}
  tenant_id       = var.hub_tenant_id
  subscription_id = var.spoke_subscription_id
  client_id       = var.spoke_client_id
  client_secret   = var.spoke_client_secret
  alias           = "spoke"
}
 */

