resource "azurerm_virtual_machine_extension" "aad_ssh_login" {
  for_each = toset(var.aad_ssh_login_enabled ? ["enabled"] : [])

  name                       = "${azurerm_linux_virtual_machine.vm.name}-AADSSHLoginForLinux"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = var.aad_ssh_login_extension_version
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  auto_upgrade_minor_version = true

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)
}

resource "azurerm_role_assignment" "rbac_user_login" {
  for_each             = toset(var.aad_ssh_login_enabled ? var.aad_ssh_login_user_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_linux_virtual_machine.vm.id
  role_definition_name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "rbac_admin_login" {
  for_each             = toset(var.aad_ssh_login_enabled ? var.aad_ssh_login_admin_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_linux_virtual_machine.vm.id
  role_definition_name = "Virtual Machine Administrator Login"
}
