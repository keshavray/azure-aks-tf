variable "resource_group_location" {
  description = "Location for resource group See. https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
}
variable "location" {
  description = "Location for VNET See. https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
}
variable "description" {
  description = "Description of the RG workload"
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
variable "tags" {
  description = "Tags to apply to resources"
}
#############################
# Function App Service Plan #
#############################
variable "storagetier" {
  description = "Storage Tier for Azure function storage"
  type        = string
}
variable "storage_replication" {
  description = "Replication of Storage for Azure function storage"
  type        = string
}
variable "kind" {
  description = "The kind of the App Service Plan to create. Possible values are Windows, Linux, elastic, FunctionApp"
  type        = string
}
variable "reserved" {
  description = "Is this App Service Plan Reserved. Defaults to false."
  type        = bool
}
variable "worker_count" {
  description = "The maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan."
  type        = string
}
variable "sku_tier" {
  description = "SKU tier to use for the Function app service plan"
  type        = string
}
variable "sku_size" {
  description = "SKU size to use for the Function app service plan"
  type        = string
}
#############################
# Function App Service Plan #
#############################
variable "app_version" {
  description = "The runtime version associated with the Function App. Defaults to ~1."
  type        = string
}
variable "https_only" {
  description = "Confgure what traffic the function app accepts HTTP and HTTPS or HTTPS"
  type        = bool
}
variable "client_affinity_enabled" {
  description = "Should the Function App send session affinity cookies, which route client requests in the same session to the same instance?"
  type        = string
}
variable "always_on" {
  description = "Set whether app service plan should always be active or can stop when inactive"
  type        = bool
}
variable "min_tls_version" {
  description = "The minimum supported TLS version for the function app. Possible values are 1.0, 1.1, and 1.2"
  type        = string
}
variable "app_name" {
  description = "Name of the app or service that uses this function"
  type        = string
}
variable "os_type" {
  description = "Operating System type for the function app"
  type        = string
}
