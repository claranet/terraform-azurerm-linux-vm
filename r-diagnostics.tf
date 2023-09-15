resource "null_resource" "fake_vm_logs_condition" {
  count = var.use_legacy_monitoring_agent ? 1 : 0

  triggers = {
    diagnostics_storage_account_name      = var.diagnostics_storage_account_name
    diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token
    vm_id                                 = azurerm_linux_virtual_machine.vm.id
  }

  lifecycle {
    precondition {
      condition     = var.diagnostics_storage_account_sas_token != null
      error_message = "Variable diagnostics_storage_account_sas_token must be set when legacy monitoring agent is enabled."
    }
  }
}

module "vm_logs" {
  for_each = toset(var.use_legacy_monitoring_agent ? ["enabled"] : [])

  source  = "claranet/vm-logs/azurerm"
  version = "4.2.0"

  environment = var.environment
  stack       = var.stack

  diagnostics_storage_account_name      = var.diagnostics_storage_account_name
  diagnostics_storage_account_sas_token = var.diagnostics_storage_account_sas_token

  vm_id = azurerm_linux_virtual_machine.vm.id

  default_tags_enabled = var.default_tags_enabled

  tags = merge(
    local.default_tags,
    {
      vm_name = azurerm_linux_virtual_machine.vm.name
    },
    var.extra_tags, var.extensions_extra_tags
  )

  depends_on = [null_resource.fake_vm_logs_condition]
}

resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  for_each = toset(var.use_legacy_monitoring_agent ? [] : ["enabled"])

  name = "${azurerm_linux_virtual_machine.vm.name}-azmonitorextension"

  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = var.azure_monitor_agent_version
  auto_upgrade_minor_version = "true"
  automatic_upgrade_enabled  = var.azure_monitor_agent_auto_upgrade_enabled

  virtual_machine_id = azurerm_linux_virtual_machine.vm.id

  tags = merge(local.default_tags, var.extra_tags, var.extensions_extra_tags)
}

resource "azurerm_monitor_data_collection_rule_association" "dcr" {
  for_each = toset(var.use_legacy_monitoring_agent ? [] : ["enabled"])

  name                    = local.dcr_name
  target_resource_id      = azurerm_linux_virtual_machine.vm.id
  data_collection_rule_id = var.azure_monitor_data_collection_rule_id
}
