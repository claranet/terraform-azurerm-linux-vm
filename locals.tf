locals {
  default_tags = {
    env   = var.environment
    stack = var.stack
  }
  default_vm_tags = {
    os_family       = "linux"
    os_distribution = lookup(var.vm_image, "offer", "undefined")
    os_version      = lookup(var.vm_image, "sku", "undefined")
  }
}
