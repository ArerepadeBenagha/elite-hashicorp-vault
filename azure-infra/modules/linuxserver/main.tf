resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = data.azurerm_resource_group.vnet.location
  resource_group_name   = data.azurerm_resource_group.vnet.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size
  tags                  = var.tags
  source_image_id       = var.vm_image_id

  dynamic "source_image_reference" {
    for_each = var.vm_image_id == null ? ["fake"] : []
    content {
      offer     = lookup(var.vm_image, "offer", null)
      publisher = lookup(var.vm_image, "publisher", null)
      sku       = lookup(var.vm_image, "sku", null)
      version   = lookup(var.vm_image, "version", null)
    }
  }

  dynamic "plan" {
    for_each = toset(var.vm_plan != null ? ["fake"] : [])
    content {
      name      = lookup(var.vm_plan, "name", null)
      product   = lookup(var.vm_plan, "product", null)
      publisher = lookup(var.vm_plan, "publisher", null)
    }
  }

  os_disk {

    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  dynamic "identity" {
    for_each = var.identity != null ? ["fake"] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  computer_name  = var.vm_name
  admin_username = var.admin_username

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key != null ? ["fake"] : []
    content {
      public_key = var.ssh_public_key
      username   = var.admin_username
    }
  }

}

resource "azurerm_managed_disk" "disk" {
  for_each             = var.storage_data_disk_config
  name                 = var.managed_disk
  location             = data.azurerm_resource_group.vnet.location
  resource_group_name  = data.azurerm_resource_group.vnet.name
  zones                = var.zone_id != null ? [var.zone_id] : []
  storage_account_type = lookup(each.value, "storage_account_type", "Standard_LRS")

  create_option = lookup(each.value, "create_option", "Empty")
  disk_size_gb  = lookup(each.value, "disk_size_gb", null)

  tags = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attachment" {
  for_each = var.storage_data_disk_config

  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id

  lun     = lookup(each.value, "lun", each.key)
  caching = lookup(each.value, "caching", "ReadWrite")
}

resource "azurerm_network_interface" "nic" {
  name                = var.nic
  location            = data.azurerm_resource_group.vnet.location
  resource_group_name = data.azurerm_resource_group.vnet.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}