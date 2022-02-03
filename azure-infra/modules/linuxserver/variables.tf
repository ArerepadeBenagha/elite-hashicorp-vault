### VM inputs
variable "tags" {
  description = "Tag for infrastructure charge."
  type        = map(any)
  default     = {}
}

variable "custom_data" {
  description = "Custom data. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#os_profile block"
  type        = any
  default     = null
}

variable "vm_size" {
  description = "Size (SKU) of the Virtual Machine to create."
  type        = string
}

variable "availability_set_id" {
  description = "Id of the availability set in which host the Virtual Machine."
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Index of the Availability Zone which the Virtual Machine should be allocated in."
  type        = number
  default     = null
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined."
  type        = map(string)

  default = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }
}

variable "vm_plan" {
  description = "Virtual Machine plan image information. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#plan. This variable has to be used for BYOS image. Before using BYOS image, you need to accept legal plan terms. See https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az_vm_image_accept_terms."
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  default = null
}

variable "storage_data_disk_config" {
  description = <<EOT
Map of objects to configure storage data disk(s).
    disk1 = {
      name                 = string ,
      create_option        = string ,
      disk_size_gb         = string ,
      lun                  = string ,
      storage_account_type = string ,
      extra_tags           = map(string)
    }
EOT
  type        = any
  default     = {}
}

variable "storage_data_disk_extra_tags" {
  description = "[DEPRECATED] Extra tags to set on each data storage disk."
  type        = map(string)
  default     = {}
}

variable "vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable cannot be used if `vm_image` is already defined."
  type        = string
  default     = null
}

## Identity variables
variable "identity" {
  description = "Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity"
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  default     = "azureinfrakey.pub"
}

variable "location" {
  description = "Azure location."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Id of the Subnet in which create the Virtual Machine"
  type        = string
}

variable "admin_username" {
  description = "Username for Virtual Machine administrator account"
  type        = string
  default     = "eliteadmin"
}

variable "nic" {
  type        = string
  description = "The nic space that is used by the virtual network."
}

variable "managed_disk" {
  type        = string
  description = "The nic space that is used by the virtual network."
}

variable "address_space" {
  type        = list(string)
  description = "The address space that is used by the virtual network."
}

variable "vm_name" {
  type        = string
  description = "The vm name."
}