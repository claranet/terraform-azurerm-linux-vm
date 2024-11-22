output "resource" {
  description = "Linux Virtual Machine  resource object."
  value       = azurerm_linux_virtual_machine.main
}

output "id" {
  description = "ID of the Virtual Machine."
  value       = azurerm_linux_virtual_machine.main.id
}

output "name" {
  description = "Name of the Virtual Machine."
  value       = azurerm_linux_virtual_machine.main.name
}

output "hostname" {
  description = "Hostname of the Virtual Machine."
  value       = azurerm_linux_virtual_machine.main.computer_name
}

output "resource_public_ip" {
  description = "VM Public IP resource object."
  value       = one(azurerm_public_ip.main[*])
}

output "public_ip_address" {
  description = "Public IP address of the Virtual Machine."
  value       = one(azurerm_public_ip.main[*].ip_address)
}

output "public_ip_id" {
  description = "Public IP ID of the Virtual Machine."
  value       = one(azurerm_public_ip.main[*].id)
}

output "public_domain_name_label" {
  description = "Public DNS of the Virtual Machine."
  value       = one(azurerm_public_ip.main[*].domain_name_label)
}

output "private_ip_address" {
  description = "Private IP address of the Virtual Machine."
  value       = azurerm_network_interface.main.private_ip_address
}

output "nic_name" {
  description = "Name of the Network Interface Configuration attached to the Virtual Machine."
  value       = azurerm_network_interface.main.name
}

output "nic_id" {
  description = "ID of the Network Interface Configuration attached to the Virtual Machine."
  value       = azurerm_network_interface.main.id
}

output "nic_ip_configuration_name" {
  description = "Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine."
  value       = local.ip_configuration_name
}

output "identity_principal_id" {
  description = "Linux Virtual Machine system identity principal ID."
  value       = try(azurerm_linux_virtual_machine.main.identity[0].principal_id, null)
}

output "admin_username" {
  description = "Virtual Machine admin username."
  value       = var.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "Virtual Machine admin password."
  value       = var.admin_password
  sensitive   = true
}

output "admin_ssh_private_key" {
  description = "Virtual Machine admin SSH private key."
  value       = var.ssh_private_key
  sensitive   = true
}

output "admin_ssh_public_key" {
  description = "Virtual Machine admin SSH public key."
  value       = var.ssh_public_key
}

output "resource_os_disk" {
  description = "Virtual Machine OS disk resource object."
  value       = data.azurerm_managed_disk.vm_os_disk
}

output "resource_maintenance_configuration_assignment" {
  description = "Maintenance configuration assignment resource object."
  value       = azurerm_maintenance_assignment_virtual_machine.main
}
