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

  name_prefix  = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]$/", "$0-") : ""
  default_name = lower("${local.name_prefix}${var.stack}-${var.client_name}-${var.location_short}-${var.environment}")

  vm_name = coalesce(var.custom_name, "${local.default_name}-vm")

  ip_configuration_name = coalesce(var.custom_ipconfig_name, "${local.vm_name}-nic-ipconfig")
}
