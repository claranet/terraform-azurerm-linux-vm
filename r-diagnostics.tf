module "vm-logs" {
  source  = "claranet/vm-logs/azurerm"
  version = "2.1.0"

  location    = var.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  vm_ids = [azurerm_virtual_machine.vm.id]

  tags = {
    environment = var.environment
    stack       = var.stack
  }
}
