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

variable "sku" {
  description = "The SKU which should be used for this Search Service"
  type        = string
}

