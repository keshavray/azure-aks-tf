variable "location" {
  description = "Location for VNET See. https://azure.microsoft.com/en-us/global-infrastructure/locations/"
  type        = string
  default     = "North Europe"
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
# Subscription Details - Peering
#########################
variable "hub_tenant_id" {
  description = "Tenant ID for the prod susbscription"
}
variable "hub_subscription_id" {
  description = "Subscription ID for hub network"
}
variable "hub_client_id" {
  description = "client ID for hub SPN account"
}
variable "hub_client_secret" {
  description = "client secret for hub SPN account"
}
/* variable "spoke_subscription_id" {
  description = "Subscription ID for spoke network"
}
variable "spoke_client_id" {
  description = "client ID for spoke SPN account"
}
variable "spoke_client_secret" {
  description = "client secret for spoke SPN account"
}
 */
variable "tfstate_access_key" {
  description = "Access key for accessing the state for the hub platform"
}