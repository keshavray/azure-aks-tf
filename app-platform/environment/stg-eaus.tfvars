product     = "cp"
squad       = "Platform Team"
environment = "stg"
role        = "pfm-1"
description = "Clinical Platform"

resource_group_location = "eastus"
location                = "eaus"

vnet_cidr        = ["10.20.0.0/16"]
vnet_dns_servers = []

tfstate_access_key = "#{hub_tfstate_key}#"