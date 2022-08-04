# See documentation in Main Platform wiki
# https://dev.azure.com/OxfordVR/Platform/_wiki/wikis/Platform.wiki/22/spoke-service-principal

$TenantID = "1b9a0349-39d1-4f9d-87ff-055c9b7d14c4"
$SpokeSubscription = "%Add-Spoke-SubscriptionID-Here%"
$SPNName = "%Add-New-SPN-Name-Here%"
$HubSPNName = "Azure-DevOps-CP-Hub-SPN-1"
$HubSubscription = "764c2874-9166-4aba-b19e-2298c8904c34"
#Azure Contianer Registry
$ACRRG = "hub-creg1-rg-eaus-prd"
$ACRName = "hubcreg1eausprd"

$HubKeyVaultRG = "hub-pfm-1-rg-eaus-prd"
$HubVaultManagedID = "hub-vault-uaid-eaus-prd"

# We use a mix of az cli and ps
az login
#Login to Azure
Connect-AzAccount -TenantId $TenantID -Subscription $SpokeSubscription

#Top level SPN to deploy resources via the Pipeline
az ad sp create-for-rbac -n $SPNName --role="Contributor" --scopes="/subscriptions/$SpokeSubscription"
#$SPN = New-AzADServicePrincipal -role "Contributor" -DisplayName $SPNName -Scope "/subscriptions/$SpokeSubscription"

$SPN = Get-AzADServicePrincipal -DisplayName $SPNName
$HubSPN = Get-AzADServicePrincipal -DisplayName $HubSPNName


#Assign user Access Administrator Role to new SPN
az role assignment create --role 'User Access Administrator' --assignee $SPN.ApplicationId --scope="/subscriptions/$SpokeSubscription" --query id -otsv


#Spoke permissions

# Log Analytics Access
#As we are adding resources to the log analytics workspace from other subscriptions we need to allow the spoke SPNs manage the Hub Log analytics.  We add the role below
az role assignment create --role "Log Analytics Contributor"  --assignee $SPN.ApplicationId --scope="/subscriptions/$HubSubscription"


## VNET Peering 
#VNet peering requires you to configure the peer on both VNets. When peering across subscriptions the terraform providers file needs two provider blocks one for hub and one for spoke network. These are each given an alias we can then reference when deploying resources. So we can deploy each side of the VNet configuration using different SPN credentials.
#To allow this to work the SPN will require Network Contributor Access
#Hub SPN requires Network Contributor Access on Spoke
#Spoke SPN requires Network Contributor Access on Hub

#Spoke permissions on hub
az role assignment create --role "Network Contributor" --assignee $SPN.ApplicationId   --scope="/subscriptions/$HubSubscription"

#Hub permissions on spoke

#IMPORTANT
#As the spoke is not created until later.  This step would have to be done after the spoke Platform is deployed.  This could be automated will add it to todo

az role assignment create --role "Network Contributor" --assignee $HubSPN.ApplicationId  --scope="/subscriptions/$SpokeSubscription"

##  Below should not be needed if above is addded as it will be inherited

## Allow spokes to manage Container registry

### private endpoint on 
#Switch to Hub subscription to apply ACR role
#az account set -s $SpokeSubscription

az role assignment create --role "Network Contributor" --assignee $SPN.ApplicationId   --scope="/subscriptions/$HubSubscription/resourceGroups/$ACRRG/providers/Microsoft.ContainerRegistry/registries/$ACRName"

## Used to allow Access and permission to Container registry 

az role assignment create --role "Contributor" --assignee $SPN.ApplicationId   --scope="/subscriptions/$HubSubscription/resourceGroups/$ACRRG/providers/Microsoft.ContainerRegistry/registries/$ACRName"

az role assignment create --role "User Access Administrator"  --assignee $SPN.ApplicationId  --scope="/subscriptions/$HubSubscription"

#providing access for Spoke SPN to access the managed identity with access to Hub Keyvault to retrieve secret
az role assignment create --role "Managed Identity Operator" --assignee $SPN.ApplicationId   --scope="/subscriptions/$HubSubscription/resourceGroups/$HubKeyVaultRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$HubVaultManagedID"
