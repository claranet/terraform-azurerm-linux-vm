resource "azurerm_virtual_machine" "vm" {
  name                  = local.vm_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  tags = merge(local.default_tags, var.extra_tags)

  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  storage_image_reference {
    id        = lookup(var.vm_image, "id", null)
    offer     = lookup(var.vm_image, "offer", null)
    publisher = lookup(var.vm_image, "publisher", null)
    sku       = lookup(var.vm_image, "sku", null)
    version   = lookup(var.vm_image, "version", null)
  }
  availability_set_id = var.availability_set_id

  boot_diagnostics {
    enabled     = true
    storage_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"
  }

  storage_os_disk {
    name              = "${local.vm_name}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = local.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password
    custom_data    = local.custom_data_content
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = var.public_key
      path     = "/home/claranet/.ssh/authorized_keys"
    }
  }
}

