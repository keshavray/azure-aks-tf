# To-Do

* Hub Platform - azurerm_dns_cname_record to be amended
* Hub KeyVault - network_acls to be amended
* Hub Security Centre - PS Script to be ran
* Add NSG Rules
* App KeyVault - network acls to be amended


# Known Issues

* Pipeline warning:
    * "##[warning]Multiple provider blocks specified in the .tf files in the current working drectory."

    Even when using a single provider this error appears. [Open PR](https://github.com/microsoft/azure-pipelines-extensions/pull/852) awaiting merge to fix this in the Azure DevOps Extension.


# Service bus sku

We have used standard, if this needs to be zone redundant it would need to change to premium