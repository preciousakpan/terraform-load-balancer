output "pip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_address
}

output "prip" {
  value = azurerm_linux_virtual_machine.vm.private_ip_address
}

output "nic" {
  value  = azurerm_network_interface.nic.id
}

output "nic-ip-name" {
  value  = azurerm_network_interface.nic.ip_configuration[0]
}