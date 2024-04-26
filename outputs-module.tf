output "terraform_module" {
  description = "Information about this Terraform module"
  value = {
    name       = "linux-vm"
    provider   = "azurerm"
    maintainer = "claranet"
  }
}
