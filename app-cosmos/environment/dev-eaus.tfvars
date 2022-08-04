product     = "cp"
squad       = "Platform Team"
environment = "dev"
role        = "cosmos"
description = "Cosomos DB Resources"

resource_group_location = "eastus"
location                = "eaus"

failover_location      = "eastus2"
failover_location_code = "eaus2"

subnet_cidr       = "10.10.1.0/24"
service_endpoints = ["Microsoft.AzureCosmosDB"]
route_table_id    = ""

cosmos-server = {
  kind = "GlobalDocumentDB"

}
