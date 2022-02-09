locals {
  # Common tags to be assigned to all resources
  common_tags = {
    Service          = "Elite Technology Services"
    Company          = "EliteSolutions LLC"
    subscriptionname = "elitelabtools"
    ManagedWith      = "Terraform"
  }

  network = {
    resource_group_name                 = "devinfranetRG"
    address_space                       = ["10.0.0.0/16"]
    cidr                                = ["10.0.1.0/24"]
    subnet_name                         = "main-subnet"
    azure_bastion_subnet_address_prefix = ["10.0.2.0/24"]
  }

  application = {
    alias       = "dev"
    buildregion = "eastus"
  }

  database = {
    administrator_login                      = "sqldb"
    administrator_password                   = "$^XcpO9$Tp^^"
    sql_server                               = "sqlserverdb"
    sql_account                              = "sqlserveracnt"
    sql_db                                   = "sqldbelite"
    advanced_data_security_additional_emails = ["lbenagha@gmail.com"]
  }
}