data "azurerm_managed_disk" "vm_os_disk" {
  name                = local.os_disk_name
  resource_group_name = var.resource_group_name

  depends_on = [azurerm_linux_virtual_machine.main]
}
