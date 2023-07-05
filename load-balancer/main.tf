resource "azurerm_public_ip" "pip" {
  name                = "PublicIPForLB"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Dynamic"
}

resource "azurerm_lb" "alb" {
  name                = var.lb_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "bap" {
  loadbalancer_id = azurerm_lb.alb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "alb-rule" {
  loadbalancer_id                = azurerm_lb.alb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}

resource "azurerm_lb_probe" "alb-probe" {
  loadbalancer_id = azurerm_lb.alb.id
  name            = "Http-running-probe"
  port            = 80
}

resource "azurerm_network_interface_backend_address_pool_association" "nic-bap" {
  network_interface_id    = var.nic_id
  ip_configuration_name   = "PublicIPAddress"
  backend_address_pool_id = azurerm_lb_backend_address_pool.bap.id
}