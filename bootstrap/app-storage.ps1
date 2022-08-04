# The following script will create Azure resource group, Storage account and a Storage container which will be used to store terraform state
$product = "cp"
$role = "tf"
$location_short = $env:LOC
$location = "eastus"
#You cannot use hyphens in storage account names
$environment = $env:ENV
$terraform_state_RG = "$product-$role-state-rg-$location_short-$environment"
$terraform_state_storage_account = "$product$role"+"str1"+"$location_short"+"$environment"
$terraform_state_container_name = "tfstate"
$sku = "Standard_GRS"

az group create --location $location --name $terraform_state_RG

az storage account create --name $terraform_state_storage_account --resource-group $terraform_state_RG --location $location --sku $sku 

az lock create --name tfstoragelock --lock-type CanNotDelete --resource-group $terraform_state_RG --resource-name $terraform_state_storage_account --resource-type Microsoft.Storage/storageAccounts

az storage container create --name $terraform_state_container_name --account-name $terraform_state_storage_account
