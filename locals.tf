locals {
  backup_resource_group_name = var.backup_policy != null ? split("/", var.backup_policy.id)[4] : null
  backup_recovery_vault_name = var.backup_policy != null ? split("/", var.backup_policy.id)[8] : null
}
