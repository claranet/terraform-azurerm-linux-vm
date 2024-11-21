resource "azurerm_virtual_machine_extension" "aad_ssh_login" {
  count = var.entra_ssh_login_enabled ? 1 : 0

  name                       = "${azurerm_linux_virtual_machine.main.name}-AADSSHLoginForLinux"
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADSSHLoginForLinux"
  type_handler_version       = var.entra_ssh_login_extension_version
  virtual_machine_id         = azurerm_linux_virtual_machine.main.id
  auto_upgrade_minor_version = true

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)
}

moved {
  from = azurerm_virtual_machine_extension.aad_ssh_login["enabled"]
  to   = azurerm_virtual_machine_extension.aad_ssh_login[0]
}

resource "azurerm_role_assignment" "rbac_user_login" {
  for_each             = toset(var.entra_ssh_login_enabled ? var.entra_ssh_login_user_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_linux_virtual_machine.main.id
  role_definition_name = "Virtual Machine User Login"
}

resource "azurerm_role_assignment" "rbac_admin_login" {
  for_each             = toset(var.entra_ssh_login_enabled ? var.entra_ssh_login_admin_objects_ids : [])
  principal_id         = each.value
  scope                = azurerm_linux_virtual_machine.main.id
  role_definition_name = "Virtual Machine Administrator Login"
}
