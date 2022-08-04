resource "azurerm_mssql_database" "Agents" {
  name        = join("_", ["Agents", var.environment])
  server_id   = azurerm_sql_server.mssql.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = var.mssql-agents-max-size-gb
  sku_name    = var.mssql-agents-sku 

  tags = local.tags
}

resource "azurerm_mssql_database" "Appointments" {
  name        = join("_", ["Appointments", var.environment])
  server_id   = azurerm_sql_server.mssql.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = var.mssql-appointments-max-size-gb
  sku_name    = var.mssql-appointments-sku

  tags = local.tags
}


resource "azurerm_mssql_database" "Notifications" {
  name        = join("_", ["Notifications", var.environment])
  server_id   = azurerm_sql_server.mssql.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = var.mssql-notifications-max-size-gb
  sku_name    = var.mssql-notifications-sku

  tags = local.tags
}


resource "azurerm_mssql_database" "Patients" {
  name        = join("_", ["Patients", var.environment])
  server_id   = azurerm_sql_server.mssql.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = var.mssql-patients-max-size-gb
  sku_name    = var.mssql-patients-sku

  short_term_retention_policy {

    retention_days = 35

  }

  long_term_retention_policy {

    weekly_retention  = "P4W"
    monthly_retention = "P12M"
    yearly_retention  = "P5Y"
    week_of_year      = 1

  }

  tags = local.tags
}

resource "azurerm_mssql_database" "Questionnaires" {
  name        = join("_", ["Questionnaires", var.environment])
  server_id   = azurerm_sql_server.mssql.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = var.mssql-questionnaire-max-size-gb
  sku_name    = var.mssql-questionnaires-sku

  tags = local.tags
}


resource "azurerm_mssql_database" "Payments" {
  name                        = join("_", ["Payments", var.environment])
  server_id                   = azurerm_sql_server.mssql.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = var.mssql-payments-max-size-gb
  sku_name                    = var.mssql-payments-sku
  min_capacity                = 2
  auto_pause_delay_in_minutes = -1

  tags = local.tags
}



resource "azurerm_mssql_database" "Sessions" {
  name                        = join("_", ["Sessions", var.environment])
  server_id                   = azurerm_sql_server.mssql.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb                 = var.mssql-sessions-max-size-gb
  sku_name                    = var.mssql-sessions-sku
  min_capacity                = 2
  auto_pause_delay_in_minutes = -1

  tags = local.tags
}

resource "azurerm_mssql_database" "Tasks" {
  name        = join("_", ["Tasks", var.environment])
  server_id   = azurerm_sql_server.mssql.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = var.mssql-tasks-max-size-gb
  sku_name    = var.mssql-tasks-sku

  tags = local.tags
}

resource "azurerm_mssql_database" "Users" {
  name        = join("_", ["Users", var.environment])
  server_id   = azurerm_sql_server.mssql.id
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = var.mssql-users-max-size-gb
  sku_name    = var.mssql-users-sku

  tags = local.tags
}

