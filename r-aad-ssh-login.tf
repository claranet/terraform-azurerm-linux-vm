resource "azurerm_virtual_machine_extension" "aad_ssh_login" {
  for_each = toset(var.aad_ssh_login_enabled ? ["enabled"] : [])

  name                       = "${azurerm_linux_virtual_machine.vm.name}-AADSSHLoginForLinux"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = var.aad_ssh_login_extension_version
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  auto_upgrade_minor_version = true
}
