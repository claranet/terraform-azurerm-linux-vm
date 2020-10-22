resource "azurerm_linux_virtual_machine" "vm" {
  name                = local.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  tags = merge(local.default_tags, local.default_vm_tags, var.extra_tags)

  source_image_id = var.vm_image_id

  source_image_reference {
    offer     = lookup(var.vm_image, "offer", null)
    publisher = lookup(var.vm_image, "publisher", null)
    sku       = lookup(var.vm_image, "sku", null)
    version   = lookup(var.vm_image, "version", null)
  }

  availability_set_id = var.availability_set_id

  zone = var.zone_id

  boot_diagnostics {
    storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  os_disk {
    name                 = coalesce(var.os_disk_custom_name, "${local.vm_name}-osdisk")
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = var.os_disk_size_gb
  }

  identity {
    type = "SystemAssigned"
  }

  computer_name  = local.vm_name
  admin_username = var.admin_username
  admin_password = var.admin_password

  custom_data = var.custom_data

  disable_password_authentication = var.admin_password != null ? false : true

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_key != null ? ["fake"] : []
    content {
      public_key = var.ssh_public_key
      username   = var.admin_username
    }
  }

}

resource "azurerm_managed_disk" "disk" {
  for_each = var.storage_data_disk_config

  location            = var.location
  resource_group_name = var.resource_group_name

  name = lookup(each.value, "name", "${local.vm_name}-datadisk${each.key}")

  zones                = [var.zone_id]
  storage_account_type = lookup(each.value, "storage_account_type", "Standard_LRS")

  create_option = lookup(each.value, "create_option", "Empty")
  disk_size_gb  = lookup(each.value, "disk_size_gb", null)

  tags = merge(local.default_tags, local.default_vm_tags, var.extra_tags, var.storage_data_disk_extra_tags)
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk-attach" {
  for_each = var.storage_data_disk_config

  managed_disk_id    = azurerm_managed_disk.disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id

  lun     = lookup(each.value, "lun", each.key)
  caching = lookup(each.value, "caching", "ReadWrite")
}
