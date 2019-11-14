output "vm_id" {
  description = "ID of the Virtual Machine"
  value       = azurerm_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the Virtual Machine"
  value       = azurerm_virtual_machine.vm.name
}

output "vm_public_ip_address" {
  description = "Public IP address of the Virtual Machine"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "vm_private_ip_address" {
  description = "Private IP address of the Virtual Machine"
  value       = azurerm_network_interface.nic.private_ip_address
}

