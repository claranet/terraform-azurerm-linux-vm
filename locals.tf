locals {
  default_tags = {
    env              = var.environment
    stack            = var.stack
    os_family        = "linux"
    os_distribution  = "undefined"
    os_version       = "undefined"
    patch_management = "enabled"
  }

  vm_name = coalesce(var.custom_name, format("%s-%s-%s-%s-vm", var.stack, var.client_name, var.location_short, var.environment))

  ip_configuration_name = "configuration"
}
