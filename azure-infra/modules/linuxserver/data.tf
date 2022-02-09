data "azurerm_resource_group" "vnet" {
  name = join("infra", [local.application.alias, "netRG", ])
}