output "frontend-pip" {
    value           = azurerm_public_ip.pip.ip_address
}

output "backend-pool" {
    value           = azurerm_lb_backend_address_pool.bap.backend_ip_configurations 
}