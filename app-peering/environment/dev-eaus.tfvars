product     = "cp"
squad       = "Platform Team"
environment = "dev"
role        = "pfm"
description = "Clinical Application Hub and Spoke Peering "

resource_group_location = "eastus"
location                = "eaus"

hub_tenant_id = "#{hub_tenant_id}#"
hub_subscription_id = "#{hub_subscription_id}#"
hub_client_id= "#{hub_client_id}#"
hub_client_secret = "#{hub_client_secret}#"
/* 
spoke_subscription_id = "#{SPOKE_SUBS_ID}#"
spoke_client_id = "#{SPOKE_CLIENT_ID}#"
spoke_client_secret = "#{SPOKE_CLIENT_SECRET}#" */

tfstate_access_key = "#{hub_tfstate_key}#"