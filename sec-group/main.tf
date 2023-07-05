resource "azurerm_network_security_group" "pnsg" {
  name                = var.nsg_name
  location            = var.rg-location
  resource_group_name = var.rg-name
}

resource "azurerm_subnet_network_security_group_association" "pnsga" {
  subnet_id                 = var.snet-id
  network_security_group_id = azurerm_network_security_group.pnsg.id
}

resource "azurerm_network_security_rule" "example" {
  for_each                    = var.sgr
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = var.rg-name
  network_security_group_name = azurerm_network_security_group.pnsg.name
}