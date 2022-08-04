product     = "cp"
squad       = "Platform Team"
environment = "dev"
role        = "aks-1"
description = "Clinical Platform AKS cluster"

resource_group_location = "eastus"
location                = "eaus"

tfstate_access_key = "#{hub_tfstate_key}#"

subnet_cidr       = ["10.10.128.0/21"]
service_endpoints = ["Microsoft.Sql", "Microsoft.ContainerRegistry", "Microsoft.Storage", "Microsoft.AzureActiveDirectory"]
route_table_id    = ""

appgw_subnet_cidr       = ["10.10.3.0/24"]
appgw_service_endpoints = []

kubernetes_version = "1.20.7"

agentpool_username = "linadmin"
agentpool_name     = "agentpool"
#agent_count        = 5
agentpool_vmsize = "Standard_E4as_v4"

aks_service_cidr   = "10.11.0.0/16"
aks_dns            = "10.11.0.10"
docker_bridge_cidr = "172.17.0.1/16"
ssh_public_key     = ".//ssh//id_rsa.pub"


aks_admin_groups = "d214b933-7c2d-4408-92e7-44d99cd1bb88"

################################
# Auto-scaling options for AKS #
################################
enable_auto_scaling = true
min_count           = 2
max_count           = 5
max_pods            = 30

max_graceful_termination_sec     = 600
scale_down_delay_after_add       = "10m"
scale_down_delay_after_failure   = "3m"
scan_interval                    = "10s"
scale_down_utilization_threshold = 0.5

################################
#App GW                        #
################################

app_gateway_sku  = "Standard_v2"
app_gateway_tier = "Standard_v2"