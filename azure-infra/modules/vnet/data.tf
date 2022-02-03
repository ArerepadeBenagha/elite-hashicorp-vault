data "azurerm_resource_group" "vnet" {
  name = join("infra", [local.application.alias, "netRG", ])
}

data "azurerm_resource_group" "vnetrg" {
  name = join("infra", [local.application.alias, "rg", ])
}