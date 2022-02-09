resource "azurerm_sql_server" "server" {
  name = join("dev", [var.sql_server, "sql"])

  location            = var.location
  resource_group_name = var.resource_group_name

  version                      = var.server_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password

  tags = var.tags
}

resource "azurerm_storage_account" "sql_account" {
  name                     = join("dev", [var.sql_account, "sql"])
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_sql_database" "sql_db" {
  name                = join("dev", [var.sql_db, "sql"])
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_sql_server.server.name

  threat_detection_policy {
    email_account_admins = var.enable_advanced_data_security_admin_emails ? "Enabled" : "Disabled"
    email_addresses      = var.advanced_data_security_additional_emails
    state                = var.enable_advanced_data_security ? "Enabled" : "Disabled"
  }

  tags = var.tags
}