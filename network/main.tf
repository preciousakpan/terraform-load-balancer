resource "azurerm_virtual_network" "v-net" {
  name                = var.vnet_name
  address_space       = var.vnet_ip
  location            = var.rg_location
  resource_group_name = var.rg_name
}


resource "azurerm_subnet" "p-sn" {
  name                 = var.snet_name
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.v-net.name
  address_prefixes     = var.snet_ip
}