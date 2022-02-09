# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.91.0"
    }
  }
  required_version = ">= 0.13"
}

provider "azurerm" {
  features {}
}

# variable login_username {}
# variable login_password {}

# provider "vault" {
#   address = "https://elitevault-dev.elitelabtools.com"
#   auth_login {
#     path = "auth/userpass/login/${var.login_username}"

#     parameters = {
#       password = var.login_password
#     }
#   }
# }