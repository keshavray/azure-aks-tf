# AKS AD Group

As well as permissions the permissions assigned to a users in Azure you need additional access configure to gain administrative access to the cluster. AKS is integrated with Azure AD, you need to add any AD groups that need admin access. In ```aks.tf``` you should add the AD group IDs to the block below;


 ```role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      admin_group_object_ids = ["f76e5a84-7bd6-4a3b-adcb-b7e5f33c16d1", "f938b130-152f-4fb8-ba53-57b1510fa781"]
    }
  }
  ```
The current configuration has the following IDs, so if you are a member of these groups you will have admin access to manage the AKS cluster.

TO DO
Create user groups with AD access

