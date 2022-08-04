variable "resource_group_location" {
  description = "Location for resource group See. https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
}
variable "location" {
  description = "Location for VNET See. https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
}
variable "product" {
  description = "Enter the name of the application or service"
}
variable "environment" {
  description = "Enter the environment name"
}
variable "squad" {
  description = "Squad responsible for the the application"
}
variable "role" {
  description = "Enter role such as platform"
}
variable "description" {
  description = "A description for the application"
}

#########################
#Subnets
#########################

variable "subnet_cidr" {
  description = "The address prefix to use for the subnet, in cidr format"
}
variable "service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet. "
}

variable "appgw_subnet_cidr" {
  description = "The address prefix to use for the subnet, in cidr format"
}
variable "appgw_service_endpoints" {
  description = "The list of Service endpoints to associate with the subnet. "
}
variable "route_table_id" {
  description = "The ID of the Route Table to associate with the subnet."
}
#########################
#AKS
#########################
variable "kubernetes_version" {
  description = "Version of Kubernetes being used within the cluster"
}


/* #For SPN
variable "client_id" {}
variable "client_secret" {}
 */
variable "agentpool_username" {
  description = "Username for the Linux agent pool nodes"
}
variable "ssh_public_key" {
  description = "The list of Service endpoints to associate with the subnet. "
}
variable "agentpool_name" {
  description = "Name to assign to the agent pool. "
}
/* variable "agent_count" {
  description = "Number of Agent VMs to deploy to the cluster. "
}  */
variable "agentpool_vmsize" {
  description = "SKU to use for the virutal machines. "
}

variable "aks_service_cidr" {
  description = "The subnet range to use for the AKS service. "
}
variable "aks_dns" {
  description = "The DNS IP to use for the AKS service. "
}
variable "docker_bridge_cidr" {
  description = "The subnet range to use for for the docker brid. "
}


/* 
variable log_analytics_workspace_name {
    default = "testLogAnalyticsWorkspaceName"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}
  */
################################
# Auto-scaling options for AKS #
################################
variable "enable_auto_scaling" {
  description = "Should the Kubernetes Auto Scaler be enabled for this Node Pool? Defaults to false."
}
variable "min_count" {
  description = "The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100. "
}
variable "max_count" {
  description = "The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100."
}
variable "max_pods" {
  description = "The maximum number of pods that can run on each agent. Changing this forces a new resource to be created. "
}

variable "max_graceful_termination_sec" {
  description = "Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node. Defaults to 600. "
}
variable "scale_down_delay_after_add" {
  description = "How long after the scale up of AKS nodes the scale down evaluation resumes. Defaults to 10m."
}
variable "scale_down_delay_after_failure" {
  description = "How long after scale down failure that scale down evaluation resumes. Defaults to 3m. "
}
variable "scan_interval" {
  description = "How often the AKS Cluster should be re-evaluated for scale up/down. Defaults to 10s. "
}
variable "scale_down_utilization_threshold" {
  description = "Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down. Defaults to 0.5. "
}

################################
#App GW                       #
################################

variable "app_gateway_sku" {
  description = "Name of the Application Gateway SKU"
  default     = "Standard_v2"
}

variable "app_gateway_tier" {
  description = "Tier of the Application Gateway tier"
  default     = "Standard_v2"
}

variable "tfstate_access_key" {
  description = "Access key for accessing the state for the hub platform"
}
variable "aks_admin_groups" {
  description = "A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster."
}
