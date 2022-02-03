resource "azurerm_resource_group" "azurerm_rg" {
  name     = var.name
  location = var.location
  tags     = var.tags
}