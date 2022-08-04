# Key Vault

The keyvault in platform is used to store the secrets for SQL and other resources. From Azure DevOps we can create a variable group that can access these keyvaults.  We need to ensure the SPN that is accessing the keyvault has get, list access on the secrets. The keyvault then either needs to allow all networks to access the keyvault or to lock this down we can add the IPs for Azure DevOps.  This may need to be reviewed occasionally as it may change.

https://docs.microsoft.com/en-us/azure/devops/organizations/security/allow-list-ip-url?view=azure-devops#inbound-connections 