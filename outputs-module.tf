output "terraform_module" {
  description = "Information about this Terraform module"
  value = {
    name       = "linux-vm"
    version    = file("${path.module}/VERSION")
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
