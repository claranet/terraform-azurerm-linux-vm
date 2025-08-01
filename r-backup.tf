resource "azurerm_backup_protected_vm" "main" {
  count = var.backup_policy != null ? 1 : 0

  resource_group_name = local.backup_resource_group_name
  recovery_vault_name = local.backup_recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.main.id
  backup_policy_id    = var.backup_policy.id
  exclude_disk_luns   = var.backup_policy.exclude_disk_luns
}

moved {
  from = azurerm_backup_protected_vm.backup["enabled"]
  to   = azurerm_backup_protected_vm.main[0]
}
