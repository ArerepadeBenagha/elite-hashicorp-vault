data "azurerm_resource_group" "rg" {
  name = var.RG_network
}

data "azurerm_virtual_network" "interface" {
  name                = var.vnet_name
  resource_group_name = var.RG_network
}