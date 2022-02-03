resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.vnet.name
  location            = var.vnet_location != null ? var.vnet_location : data.azurerm_resource_group.vnet.location
  address_space       = var.address_space
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "app"
  resource_group_name  = data.azurerm_resource_group.vnet.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.cidr
}

resource "azurerm_route_table" "rtb" {
  name                          = join("infra", [local.application.alias, "rtb", ])
  location                      = var.vnet_location != null ? var.vnet_location : data.azurerm_resource_group.vnet.location
  resource_group_name           = data.azurerm_resource_group.vnet.name
  disable_bgp_route_propagation = false
  tags                          = var.tags
}

resource "azurerm_application_security_group" "appsg" {
  name                = join("infra", [local.application.alias, "appsg", ])
  location            = var.vnet_location != null ? var.vnet_location : data.azurerm_resource_group.vnet.location
  resource_group_name = data.azurerm_resource_group.vnet.name
  tags                = var.tags
}

resource "azurerm_network_security_group" "netsg" {
  name                = join("infra", [local.application.alias, "netsg", ])
  location            = var.vnet_location != null ? var.vnet_location : data.azurerm_resource_group.vnet.location
  resource_group_name = data.azurerm_resource_group.vnet.name
  tags                = var.tags
}