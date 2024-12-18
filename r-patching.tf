resource "azurerm_maintenance_assignment_virtual_machine" "main" {
  for_each                     = toset(var.maintenance_configurations_ids)
  location                     = azurerm_linux_virtual_machine.main.location
  maintenance_configuration_id = each.value
  virtual_machine_id           = azurerm_linux_virtual_machine.main.id

  lifecycle {
    precondition {
      condition     = var.patch_mode == "AutomaticByPlatform"
      error_message = "The variable patch_mode must be set to AutomaticByPlatform to use maintenance configurations."
    }
  }
}

moved {
  from = azurerm_maintenance_assignment_virtual_machine.maintenance_configurations
  to   = azurerm_maintenance_assignment_virtual_machine.main
}
