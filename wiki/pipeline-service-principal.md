# SPN Creation

az ad sp create-for-rbac -n "Azure-DevOps-CP-Prod-SPN" --role="Contributor" --scopes="/subscriptions/<subscription-id>"

To be able to assign locks you need  some permission to manage `Microsoft.Authorization/*` or `Microsoft.Authorization/locks/*` only Owner and User Access Administrator are granted those actions. So we also assign the SPN the `User Access Administrator` role

https://docs.microsoft.com/en-us/rest/api/resources/managementlocks

az role assignment create --role 'User Access Administrator' --assignee ${IDENTITY_CLIENT_ID} --scope "/subscriptions/<subscription-id>" --query id -otsv