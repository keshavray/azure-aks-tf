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
variable "route_table_id" {
  description = "The ID of the Route Table to associate with the subnet."
}

#########################
#Cosmos
#########################
variable "failover_location" {
  description = "Full Location for failover See. https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
}

variable "failover_location_code" {
  description = "Location code for failover See. https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
}

variable "cosmos-server" {
  type = object(
    {
      kind = string

    }
  )
}
