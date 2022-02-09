variable "administrator_login" {
  description = "Administrator login for SQL Server"
  type        = string
}

variable "administrator_password" {
  description = "Administrator password for SQL Server"
  type        = string
}

variable "server_version" {
  description = "Version of the SQL Server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). See https://www.terraform.io/docs/providers/azurerm/r/sql_server.html#version"
  type        = string
  default     = "12.0"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure location for SQL Server."
  type        = string
}

variable "sql_server" {
  description = "Azure SQL Server Database Name."
  type        = string
}

variable "sql_db" {
  description = "Azure SQL Database Name."
  type        = string
}

variable "sql_account" {
  description = "Azure Storage account for Database."
  type        = string
}

variable "enable_advanced_data_security" {
  description = "Boolean flag to enable Advanced Data Security. The cost of ADS is aligned with Azure Security Center standard tier pricing. See https://docs.microsoft.com/en-us/azure/sql-database/sql-database-advanced-data-security"
  type        = bool
  default     = false
}

variable "enable_advanced_data_security_admin_emails" {
  description = "Boolean flag to define if account administrators should be emailed with Advanced Data Security alerts."
  type        = bool
  default     = false
}

variable "advanced_data_security_additional_emails" {
  description = "List of addiional email addresses for Advanced Data Security alerts."
  type        = list(string)

  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/1974
  default = ["lbenagha@gmail.com"]
}