resource "azurerm_virtual_machine_extension" "log_extension" {
  count = var.log_analytics_agent_enabled ? 1 : 0

  name = "${azurerm_linux_virtual_machine.vm.name}-logextension"

  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OMSAgentforLinux"
  type_handler_version       = var.log_analytics_agent_version
  auto_upgrade_minor_version = true

  virtual_machine_id = azurerm_linux_virtual_machine.vm.id

  settings = <<SETTINGS
  {
    "workspaceId": "${var.log_analytics_workspace_guid}"
  }
SETTINGS

  protected_settings = <<SETTINGS
  {
    "workspaceKey": "${var.log_analytics_workspace_key}"
  }
SETTINGS
}

