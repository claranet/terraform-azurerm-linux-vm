module "vm-logs" {
  #source  = "claranet/vm-logs/azurerm"
  #version = "3.0.0"
  source = "git::ssh://git@git.fr.clara.net/claranet/projects/cloud/azure/terraform/modules/vm-logs.git?ref=AZ-198-azurerm-2-0"

  location    = var.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack

  resource_group_name = var.resource_group_name

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  vm_ids = [azurerm_linux_virtual_machine.vm.id]

  tags = {
    environment = var.environment
    stack       = var.stack
    vm_name     = azurerm_linux_virtual_machine.vm.name
  }
}
