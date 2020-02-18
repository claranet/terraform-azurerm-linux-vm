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

  dynamic "storage_data_disk" {
    for_each = var.storage_data_disk_config
    content {
      name              = lookup(storage_data_disk.value, "name", "${local.vm_name}-datadisk${storage_data_disk.key}")
      create_option     = lookup(storage_data_disk.value, "create_option", "Empty")
      managed_disk_type = lookup(storage_data_disk.value, "managed_disk_type", lookup(storage_data_disk.value, "vhd_uri", null) == null ? "Standard_LRS" : null)
      vhd_uri           = lookup(storage_data_disk.value, "vhd_uri", null)
      disk_size_gb      = lookup(storage_data_disk.value, "disk_size_gb", null)
      lun               = lookup(storage_data_disk.value, "lun", storage_data_disk.key)
    }
  }

  os_disk {
    name              = lookup(var.storage_os_disk_config, "name", "${local.vm_name}-osdisk")
    caching           = lookup(var.storage_os_disk_config, "caching", "ReadWrite")
    create_option     = lookup(var.storage_os_disk_config, "create_option", "FromImage")
    managed_disk_type = lookup(var.storage_os_disk_config, "managed_disk_type", lookup(var.storage_os_disk_config, "vhd_uri", null) == null ? "Standard_LRS" : null)
    vhd_uri           = lookup(var.storage_os_disk_config, "vhd_uri", null)
    os_type           = lookup(var.storage_os_disk_config, "os_type", null)
    disk_size_gb      = lookup(var.storage_os_disk_config, "disk_size_gb", null)
  }

  computer_name  = local.vm_name
  admin_username = var.admin_username

  disable_password_authentication = true

  admin_ssh_key {
    public_key = var.ssh_public_key
    username   = var.admin_username
  }
}
