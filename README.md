# Azure Linux Virtual Machine

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/linux-vm/azurerm/)

This module creates a [Linux Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/).

Following tags are automatically set with default values: `env`, `stack`, `os_family`, `os_distribution`, `os_version`.

## Requirements
* [AzureRM Terraform provider](https://www.terraform.io/docs/providers/azurerm/) >= 1.31

## Terraform version compatibility
 
| Module version | Terraform version |
|----------------|-------------------|
| >= 2.x.x       | 0.12.x            |
| < 2.x.x        | 0.11.x            |

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure-region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure-region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure-network-vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment      = var.environment
  location         = module.azure-region.location
  location_short   = module.azure-region.location_short
  client_name      = var.client_name
  stack            = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "network-security-group" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
}

module "azure-network-route-table" {
  source  = "claranet/route-table/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
}

module "azure-network-subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location_short = module.azure-region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure-network-vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.10.0/24"]

  route_table_ids = {
    keys(local.subnets)[0] = module.azure-network-route-table.route_table_id
  }

  network_security_group_ids = {
    keys(local.subnets)[0] = module.network-security-group.network_security_group_id
  }
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.azure-region.location_short}-${var.environment}-as"
  location            = module.azure-region.location
  resource_group_name = module.rg.resource_group_name
  managed             = "true"
}

module "run-common" {
  source = "claranet/run-common/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  tenant_id = var.azure_tenant_id
}

module "vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "x.x.x"

  location            = module.azure-region.location
  location_short      = module.azure-region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  subnet_id                             = element(module.azure-network-subnet.subnet_ids, 0)
  diagnostics_storage_account_name      = module.run-common.logs_storage_account_name
  diagnostics_storage_account_sas_token = lookup(module.run-common.logs_storage_account_sas_token, "sastoken")
  vm_size                               = "Standard_B2s"
  custom_name                           = "app-${var.stack}-${var.client_name}-${module.azure-region.location_short}-${var.environment}-vm"
  admin_username                        = var.vm_admin_username
  ssh_public_key                        = var.public_key

  availability_set_id              = azurerm_availability_set.vm_avset.id
  # or use Availability Zone
  # zone_id = 1

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
|------|-------------|------|---------|:--------:|
| admin\_username | Username for Virtual Machine administrator account | `string` | n/a | yes |
| application\_gateway\_backend\_pool\_id | Id of the Application Gateway Backend Pool to attach the VM. | `string` | `null` | no |
| attach\_application\_gateway | True to attach this VM to an Application Gateway | `bool` | `false` | no |
| attach\_load\_balancer | True to attach this VM to a Load Balancer | `bool` | `false` | no |
| availability\_set\_id | Id of the availability set in which host the Virtual Machine. | `string` | `null` | no |
| certificate\_validity\_in\_months | The created certificate validity in months | `string` | `"48"` | no |
| client\_name | Client name/account used in naming | `string` | n/a | yes |
| custom\_data | Custom data. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#os_profile block | `any` | `null` | no |
| custom\_dns\_label | The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com | `string` | `""` | no |
| custom\_ipconfig\_name | Custom name for the IP config of the NIC. Should be suffixed by "-nic-ipconfig". Generated if not set. | `string` | `null` | no |
| custom\_name | Custom name for the Virtual Machine. Should be suffixed by "-vm". Generated if not set. | `string` | `""` | no |
| custom\_nic\_name | Custom name for the NIC interface. Should be suffixed by "-nic". Generated if not set. | `string` | `null` | no |
| custom\_public\_ip\_name | Custom name for public IP. Should be suffixed by "-pubip". Generated if not set. | `string` | `null` | no |
| delete\_data\_disks\_on\_termination | Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed? | `bool` | `false` | no |
| delete\_os\_disk\_on\_termination | Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed? | `bool` | `false` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | SAS token of the Storage Account in which store vm diagnostics | `string` | n/a | yes |
| environment | Project environment | `string` | n/a | yes |
| extra\_tags | Extra tags to set on each created resource. | `map(string)` | `{}` | no |
| load\_balancer\_backend\_pool\_id | Id of the Load Balancer Backend Pool to attach the VM. | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| nic\_enable\_accelerated\_networking | Should Accelerated Networking be enabled? Defaults to `false`. | `bool` | `false` | no |
| os\_disk\_size\_gb | Specifies the size of the OS disk in gigabytes | `string` | `null` | no |
| os\_disk\_type | Specifies the type of managed disk to create (Standard\_LRS, StandardSSD\_LRS, Premium\_LRS) | `string` | `"Standard_LRS"` | no |
| public\_ip\_sku | Sku for the public IP attached to the VM. Can be `null` if no public IP needed. | `string` | `"Standard"` | no |
| resource\_group\_name | Resource group name | `string` | n/a | yes |
| ssh\_public\_key | SSH public key | `string` | n/a | yes |
| stack | Project stack name | `string` | n/a | yes |
| subnet\_id | Id of the Subnet in which create the Virtual Machine | `string` | n/a | yes |
| vm\_image | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference | `map(string)` | <pre>{<br>  "offer": "debian-10",<br>  "publisher": "Debian",<br>  "sku": "10",<br>  "version": "latest"<br>}</pre> | no |
| vm\_size | Size (SKU) of the Virtual Machine to create. | `string` | n/a | yes |
| zone\_id | Index of the Availability Zone which the Virtual Machine should be allocated in. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| vm\_id | ID of the Virtual Machine |
| vm\_name | Name of the Virtual Machine |
| vm\_nic\_ip\_configuration\_name | Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine |
| vm\_nic\_name | Name of the Network Interface Configuration attached to the Virtual Machine |
| vm\_private\_ip\_address | Private IP address of the Virtual Machine |
| vm\_public\_domain\_name\_label | Public DNS of the Virtual machine |
| vm\_public\_ip\_address | Public IP address of the Virtual Machine |

## Related documentation

Terraform resource documentation: [www.terraform.io/docs/providers/azurerm/r/virtual\_machine.html](https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html)

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machines/linux/](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/)
