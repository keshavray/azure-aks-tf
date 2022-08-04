# SQL Credentials

We get the credentials from the Clinical Platform Key Vault.  This means that before you deploy the SQL server you need to generate the SQL username and password and place this in the keyvault.

Key Vault
Resource group:  cp-pfm-rg-<region>-<environment>
Key Vault: cp-pfm-rg-<region>-<environment>

SQL Password
"cp-mssql-<region>-<environment>-PASSWORD"

Example : "cp-mssql-eaus-prd-PASSWORD"

Example
SQL Username
"cp-mssql-<region>-<environment>-USERNAME"

