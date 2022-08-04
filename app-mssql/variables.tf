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
#MSSQL
#########################

variable "mssql-version" {
  description = "Version of the MSSQL server. "
}
#########################
#Agents DB
#########################
variable "mssql-agents-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-agents-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Appointments DB
#########################
variable "mssql-appointments-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-appointments-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Notification DB
#########################
variable "mssql-notifications-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-notifications-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Patients DB
#########################
variable "mssql-patients-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-patients-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Questionnaires DB
#########################
variable "mssql-questionnaires-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-questionnaire-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Payments DB
#########################
variable "mssql-payments-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-payments-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Sessions DB
#########################
variable "mssql-sessions-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-sessions-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Tasks DB
#########################
variable "mssql-tasks-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-tasks-max-size-gb" {
  description = "The max size of the database in gigabytes."
}
#########################
#Users DB
#########################
variable "mssql-users-sku" {
  description = "Specifies the name of the sku used by the database."
}
variable "mssql-users-max-size-gb" {
  description = "The max size of the database in gigabytes."
}