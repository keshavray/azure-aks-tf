product     = "cp"
squad       = "Platform Team"
environment = "stg"
role        = "mssql-1"
description = "MS SQL Resources"

resource_group_location = "eastus"
location                = "eaus"

subnet_cidr       = "10.20.0.0/24"
service_endpoints = ["Microsoft.Sql"]
route_table_id    = ""

mssql-version  = "12.0"

#########################
#Agents DB
#########################
mssql-agents-max-size-gb = 250
mssql-agents-sku = "S2"


#########################
#Appointments DB
#########################
mssql-appointments-max-size-gb = 250
mssql-appointments-sku = "S2"

#########################
#Notification DB
#########################
mssql-notifications-max-size-gb  = 250
mssql-notifications-sku = "S0"


#########################
#Patients DB
#########################
mssql-patients-max-size-gb = 250
mssql-patients-sku = "S0"


#########################
#Questionnaires DB
#########################
mssql-questionnaire-max-size-gb = 250
mssql-questionnaires-sku = "S2"


#########################
#Payments DB
#########################
mssql-payments-max-size-gb =  32 
mssql-payments-sku = "GP_S_Gen5_2"


#########################
#Sessions DB
#########################
mssql-sessions-max-size-gb = 32
mssql-sessions-sku  = "GP_S_Gen5_2"


#########################
#Tasks DB
#########################
mssql-tasks-max-size-gb = 250
mssql-tasks-sku = "S0"


#########################
#Users DB
#########################
mssql-users-max-size-gb = 250
mssql-users-sku = "S2"
