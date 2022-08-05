resource "azurerm_backup_protected_vm" "backup" {
  for_each = toset(var.backup_policy_id != null ? ["enabled"] : [])

  resource_group_name = local.backup_resource_group_name
  recovery_vault_name = local.backup_recovery_vault_name
  source_vm_id        = azurerm_linux_virtual_machine.vm.id
  backup_policy_id    = var.backup_policy_id
}
