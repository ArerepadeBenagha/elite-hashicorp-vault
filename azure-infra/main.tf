# ##--------------------------------------#
# //         RG Module              
# ##--------------------------------------#
module "azuremRG" {
  source   = "./modules/resourcegroups"
  name     = join("infra", [local.application.alias, "RG"])
  location = local.application.buildregion
}

# ##--------------------------------------#
# //         NetRG Module              
# ##--------------------------------------#
module "azuremRGNet" {
  source   = "./modules/resourcegroups"
  name     = join("infra", [local.application.alias, "netRG"])
  location = local.application.buildregion
}

# ##--------------------------------------#
# //         Vnet Module              
# ##--------------------------------------#
module "vnet" {
  source              = "./modules/vnet"
  vnet_name           = join("infra", [local.application.alias, "vnet"])
  vnet_location       = local.application.buildregion
  resource_group_name = join("infra", [local.application.alias, "netRG"])
  address_space       = local.network.address_space
  cidr                = local.network.cidr
  subnet_name         = local.network.subnet_name
  tags                = local.common_tags
}

# # ##--------------------------------------#
# # //         Bastion Module              
# # ##--------------------------------------#
module "azure-bastion" {
  source                              = "./modules/azure-network/"
  RG_network                          = local.network.resource_group_name
  vnet_name                           = join("infra", [local.application.alias, "vnet"])
  azure_bastion_service_name          = join("infra", [local.application.alias, "bastion"])
  azure_bastion_subnet_address_prefix = local.network.azure_bastion_subnet_address_prefix

  tags = merge(local.application,
  { Application = "jumpbox", region = local.application.buildregion })
}

# # ##--------------------------------------#
# # //         vm Module              
# # ##--------------------------------------#
module "vm" {
  source              = "./modules/linuxserver"
  location            = local.application.buildregion
  vm_name             = join("infra", [local.application.alias, "server"])
  nic                 = join("infra", [local.application.alias, "nic"])
  resource_group_name = local.network.resourcegroup_name
  subnet_id           = module.vnet.vnet_subnets
  address_space       = local.network.address_space
  vm_size             = "Standard_DS2_v2"
  admin_username      = "eliteadmin"
  managed_disk        = join("infra", [local.application.alias, "maindisk"])
  ssh_public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCikm8ZsO6/mD9iz386fTTIeTmB5uD3/elqYH6twCJioN3m2iFveFbI+unQ/viafMxLIfEt3Qlw38a6qu88Fv72s4ssxohe7LItlNaIZdBNvZ4NrjASBOsDsjZzTEdwV6Kd5izALis2r4GsBp9Y8UKYilmHa76BKWNfieFW2unNEcF8hhu8hrchBQmtMVlW+16aFurhylqVlvj603kMvf2RlgcRlbDvTA3hvrDhX4NOyjsQrAMFTNE4gxlQfNhl4rolxOtDGZyjhNdPc9IpZ4OeFhkqV68OXhlhSt79HMp+S1/YnPIsab3AHn/ntgrs/BvNb3mw4bpdAdoVSeIWvO4m8lZKKQ3kNIInwAMYc7/iMvtjXs6PCUsY2FQFGqbUrgL16NOeCOio9vFwq5v/Npb0dBCUbO/cusbKnHc/+6ufaW0dq5YoCcHWhxwcHJ+aTDkstg23hKw7nBuHlz10kUcMQndxLT+W6apeu7r+RNOy99SwsmgFaq3d082ecjCcqpE= lbena@LAPTOP-QB0DU4OG"

  tags = local.common_tags
  vm_image = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}