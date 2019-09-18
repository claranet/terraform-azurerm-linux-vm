# Azure Linux Virtual Machine

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](http://img.shields.io/badge/license-Apache%20V2-blue.svg)](LICENSE)

This module creates a [Linux Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/).

## Requirements
* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.31

## Terraform version compatibility
 
| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

## Usage

```hcl
module "azure-region" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/regions.git?ref=vX.X.X"

  azure_region = var.azure_region
}

module "rg" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/rg.git?ref=vX.X.X"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/vnet.git?ref=vX.X.X"
    
  environment      = var.environment
  location         = module.azure-region.location
  location_short   = module.azure-region.location_short
  client_name      = var.client_name
  stack            = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "network-security-group" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/nsg.git?ref=vX.X.X"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
}

module "azure-network-subnet" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/modules/subnet.git?ref=vX.X.X"

  environment     = var.environment
  location_short  = module.azure-region.location_short
  client_name     = var.client_name
  stack			      = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure-network-vnet.virtual_network_nam
  subnet_cidr_list     = ["10.10.10.0/24"]

  network_security_group_count = 1
  network_security_group_ids   = module.network-security-group.network_security_group_id
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.az-region.location_short}-${var.environment}-as"
  location            = module.azure-region.location
  resource_group_name = module.rg.resource_group_name
  managed             = "true"
}

module "vm" {
  source = "git::ssh://git@git.fr.clara.net/claranet/cloudnative/projects/cloud/azure/terraform/features/linux-vm.git?ref=vX.X.X"

  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  subnet_id                        = element(module.azure-network-subnet.subnet_ids, 0)
  availability_set_id              = azurerm_availability_set.vm_avset.id
  diagnostics_storage_account_name = data.terraform_remote_state.run.outputs.logs_storage_account_name
  vm_size                          = "Standard_B2s"
  custom_name                      = "app-${var.stack}-${var.client_name}-${module.azure-region.location_short}-${var.environment}-vm"
  admin_username                   = var.vm_admin_username
  ssh_public_key                   = var.public_key

  vm_image = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| admin\_username | Username for Virtual Machine administrator account | string | n/a | yes |
| availability\_set\_id | Id of the availability set in which host the Virtual Machine. | string | n/a | yes |
| certificate\_validity\_in\_months | The created certificate validity in months | string | `"48"` | no |
| client\_name | Client name/account used in naming | string | n/a | yes |
| custom\_dns\_label | The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com | string | `""` | no |
| custom\_ipconfig\_name | Custom name for the IP config of the NIC. Should be suffixed by \"-nic-ipconfig\". Generated if not set. | string | null | no |
| custom\_name | Custom name for the Virtual Machine. Should be suffixed by "-vm". Generated if not set. | string | `""` | no |
| custom\_nic\_name | Custom name for the NIC interface. Should be suffixed by \"-nic\". Generated if not set. | string | null | no |
| custom\_public\_ip\_name | Custom name for public IP. Should be suffixed by \"-pubip\". Generated if not set. | string | null | no |
| delete\_data\_disks\_on\_termination | Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed? | string | `"false"` | no |
| delete\_os\_disk\_on\_termination | Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed? | string | `"false"` | no |
| diagnostics\_storage\_account\_name | Storage account name to store vm boot diagnostic | string | n/a | yes |
| environment | Project environment | string | n/a | yes |
| extra\_tags | Extra tags to set on each created resource. | map | `<map>` | no |
| location | Azure location. | string | n/a | yes |
| location\_short | Short string for Azure location. | string | n/a | yes |
| resource\_group\_name | Resource group name | string | n/a | yes |
| ssh_public\_key | Public key | string | n/a | yes |
| stack | Project stack name | string | n/a | yes |
| subnet\_id | Id of the Subnet in which create the Virtual Machine | string | n/a | yes |
| vm\_image | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual\_machine.html#storage\_image\_reference | map | `<map>` | no |
| vm\_size | Size (SKU) of the Virtual Machin to create. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vm\_id | Id of the Virtual machine |
| vm\_name | Name of the Virtual machine |
| vm\_private\_ip\_address | Private IP address of the Virtual machine |
| vm\_public\_ip\_address | Public IP address of the Virtual machine |

## Related documentation

Terraform resource documentation: [www.terraform.io/docs/providers/azurerm/r/virtual_machine.html](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html)

Microsoft Azure documentation: [https://docs.microsoft.com/en-us/azure/virtual-machines/linux/]