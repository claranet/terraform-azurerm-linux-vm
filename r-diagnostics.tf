module "vm_logs" {
  for_each = toset(var.use_legacy_monitoring_agent ? ["enabled"] : [])

  source  = "claranet/vm-logs/azurerm"
  version = "3.0.0"

  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = "true"

  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
}

resource "null_resource" "azure_monitor_link" {
  provisioner "local-exec" {
    command = <<EOC
      az rest --subscription ${data.azurerm_client_config.current.subscription_id} \
              --method PUT \
              --url https://management.azure.com${azurerm_linux_virtual_machine.vm.id}/providers/Microsoft.Insights/dataCollectionRuleAssociations/${azurerm_linux_virtual_machine.vm.name}-dcrassociation?api-version=2019-11-01-preview \
              --body '{"properties":{"dataCollectionRuleId": "${var.azure_monitor_data_collection_rule_id}"}}'
EOC
  }

  triggers = {
    dcr_id = var.azure_monitor_data_collection_rule_id
    vm_id  = azurerm_linux_virtual_machine.vm.id
  }
}

resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  for_each = toset(var.use_legacy_monitoring_agent ? [] : ["enabled"])

  name = "${azurerm_linux_virtual_machine.vm.name}-azmonitorextension"

  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = var.azure_monitor_agent_version
  auto_upgrade_minor_version = "true"

  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
}

resource "null_resource" "azure_monitor_link" {
  for_each = toset(var.use_legacy_monitoring_agent ? [] : ["enabled"])

  provisioner "local-exec" {
    command = <<EOC
      az rest --subscription ${data.azurerm_client_config.current.subscription_id} \
              --method PUT \
              --url https://management.azure.com${azurerm_linux_virtual_machine.vm.id}/providers/Microsoft.Insights/dataCollectionRuleAssociations/${azurerm_linux_virtual_machine.vm.name}-dcrassociation?api-version=2019-11-01-preview \
              --body '{"properties":{"dataCollectionRuleId": "${var.azure_monitor_data_collection_rule_id}"}}'
EOC
  }

  triggers = {
    dcr_id = var.azure_monitor_data_collection_rule_id
    vm_id  = azurerm_linux_virtual_machine.vm.id
  }
}
