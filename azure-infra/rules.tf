resource "azurerm_network_security_group" "this" {
  name                = join("infra", [local.application.alias, "nsg", ])
  location            = local.application.buildregion
  resource_group_name = local.network.resource_group_name

  security_rule {
    name                       = "appinbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = module.vnet.vnet_subnets
  network_security_group_id = azurerm_network_security_group.this.id
}