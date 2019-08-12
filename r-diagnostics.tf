module "vm-logs" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vm-logs.git?ref=v2.1.0"

  location       = var.location
  location_short = var.location_short
  client_name    = var.client_name
  environment    = var.environment
  stack          = var.stack

  resource_group_name = var.resource_group_name

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  vm_id   = azurerm_virtual_machine.vm.id
  vm_name = azurerm_virtual_machine.vm.name

  tags = {
    environment = var.environment
    stack       = var.stack
  }
}
