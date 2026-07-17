resource "azurerm_key_vault_access_policy" "main" {
  count = var.key_vault != null && !var.key_vault.rbac_authorization_enabled ? 1 : 0

  key_vault_id = var.key_vault.id

  object_id = azurerm_linux_virtual_machine.main.identity[0].principal_id
  tenant_id = data.azurerm_client_config.current.tenant_id

  secret_permissions = ["Get", "List"]
}

resource "azurerm_role_assignment" "main" {
  count = var.key_vault != null && var.key_vault.rbac_authorization_enabled && var.key_vault.scopes != {} ? 1 : 0

  scope                = var.key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_virtual_machine.main.identity[0].principal_id
}

resource "azurerm_role_assignment" "scopes" {
  for_each = var.key_vault != null ? var.key_vault.scopes : {}

  scope                = each.value
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_virtual_machine.main.identity[0].principal_id
}
