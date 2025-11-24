locals {
  backup_resource_group_name = var.backup_policy != null ? split("/", var.backup_policy.id)[4] : null
  backup_recovery_vault_name = var.backup_policy != null ? split("/", var.backup_policy.id)[8] : null

  custom_public_ip_adress_id_parsed = provider::azurerm::parse_resource_id(var.custom_public_ip_address_id)
  public_ip                         = concat(azurerm_public_ip.main[*], data.azurerm_public_ip.public_ip[*])
}
