terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.62.1"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features{}
}

locals{
  counter   =  2
}

resource "azurerm_resource_group" "p-rg" {
  name     = "peeee"
  location = "Uk South"
}


module "vnet" {
  source            = "./network"
  vnet_name         = "vn"
  vnet_ip           = ["10.0.0.0/16"]
  rg_location       = azurerm_resource_group.p-rg.location
  rg_name           = azurerm_resource_group.p-rg.name
  snet_name         = "sn"
  snet_ip           = ["10.0.1.0/24"]
}

module "vm" {
    source          = "./vm"
    count           = local.counter
    rg_location     = azurerm_resource_group.p-rg.location
    rg_name         = azurerm_resource_group.p-rg.name
    snet_id         = module.vnet.snet-id
    username        = "puser"
    public_key      = "key.pub"
    vm_name         = "vm-${count.index + 1}"
    ip_name         = "ip-${count.index + 1}"
    nic_name        = "nic-${count.index + 1}"
    pip             = "pip-${count.index + 1}"
}

module "sec-group"{
  source            = "./sec-group"
  nsg_name          = "pee-nsg"
  rg-location       = azurerm_resource_group.p-rg.location
  rg-name           = azurerm_resource_group.p-rg.name
  snet-id           = module.vnet.snet-id
  sgr = {
    rule1 = {
      priority                 = 100
      direction                = "Inbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "80"
      source_address_prefix    = "*"
      destination_address_prefix = "*"
    },
    rule2 = {
      priority                 = 200
      direction                = "Inbound"
      access                   = "Allow"
      protocol                 = "Tcp"
      source_port_range        = "*"
      destination_port_range   = "22"
      source_address_prefix    = "*"
      destination_address_prefix = "*"
    }
  }
}

module "load-balancer" {
  source            = "./load-balancer"
  count             = local.counter
  rg_location       = azurerm_resource_group.p-rg.location
  rg_name           = azurerm_resource_group.p-rg.name
  lb_name           = "p-alb"
  nic_id            = module.vm[count.index].nic
}

output "public-ip"{
  value = module.vm[*].pip
}

output "private-ip"{
  value = module.vm[*].prip
}

output "lb-ips"{
  value = module.load-balancer[*].frontend-pip
}

output "backend-pool-ips"{
  value = module.load-balancer[*].backend-pool
}