resource "azapi_resource" "maintenance_configurations" {
  for_each  = toset(var.maintenance_configuration_ids)
  name      = format("%s-%s", azurerm_linux_virtual_machine.vm.name, split("/", each.value)[8]) # vmname-maintenance-name
  location  = var.location
  parent_id = azurerm_linux_virtual_machine.vm.id
  type      = "Microsoft.Maintenance/configurationAssignments@2021-09-01-preview"
  body = jsonencode({
    properties = {
      maintenanceConfigurationId = each.value
    }
  })
  tags                    = merge(local.default_tags, var.extra_tags)
  response_export_values  = ["*"]
  ignore_missing_property = true

  lifecycle {
    precondition {
      condition     = var.patch_mode != "AutomaticByPlatform"
      error_message = "The variable path_mode must be set to AutomaticByPlatform to use maintenance configurations."
    }
  }
}
