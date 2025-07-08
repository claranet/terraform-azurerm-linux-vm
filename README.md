# Azure Linux Virtual Machine

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/claranet/linux-vm/azurerm/)

This module creates a [Linux Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/).

Following tags are automatically set with default values: `env`, `stack`, `os_family`, `os_distribution`, `os_version`.

This module will also enforce some standard by default:
 - Azure Monitor agent extension is deployed
 - A backup policy attached to the VM
 - Patch management in place with Update Center

## Requirements

EncryptionAtHost feature must be enabled for disk security.

```bash
$ az feature register --namespace Microsoft.Compute --name EncryptionAtHost
```

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | OpenTofu version | AzureRM version |
| -------------- | ----------------- | ---------------- | --------------- |
| >= 8.x.x       | **Unverified**    | 1.8.x            | >= 4.0          |
| >= 7.x.x       | 1.3.x             |                  | >= 3.0          |
| >= 6.x.x       | 1.x               |                  | >= 3.0          |
| >= 5.x.x       | 0.15.x            |                  | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   |                  | >= 2.0          |
| >= 3.x.x       | 0.12.x            |                  | >= 2.0          |
| >= 2.x.x       | 0.12.x            |                  | < 2.0           |
| <  2.x.x       | 0.11.x            |                  | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

⚠️ Since modules version v8.0.0, we do not maintain/check anymore the compatibility with
[Hashicorp Terraform](https://github.com/hashicorp/terraform/). Instead, we recommend to use [OpenTofu](https://github.com/opentofu/opentofu/).

```hcl
resource "azurerm_availability_set" "main" {
  name                = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-as"
  location            = module.azure_region.location
  resource_group_name = module.rg.name
  managed             = true
}

module "vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.name

  subnet         = module.subnet
  vm_size        = "Standard_B2s"
  admin_username = var.vm_administrator_login
  ssh_public_key = var.ssh_public_key

  diagnostics_storage_account_name = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule = {
    id = module.run.data_collection_rule_id
  }

  # Set to null to deactivate backup
  backup_policy = {
    id = module.run.vm_backup_policy_id
  }

  patch_mode                     = "AutomaticByPlatform"
  maintenance_configurations_ids = [module.run.maintenance_configurations["Donald"].id, module.run.maintenance_configurations["Hammer"].id]

  availability_set = azurerm_availability_set.main
  # or use Availability Zone
  # zone_id = 1

  vm_image = {
    publisher = "Canonical"
    offer     = "Ubuntu"
    sku       = "24_04-lts"
  }

  # The feature must be activated upstream:
  # az feature register --namespace Microsoft.Compute --name EncryptionAtHost --subscription <subscription_id_or_name>
  encryption_at_host_enabled = true

  storage_data_disk_config = {
    appli_data_disk = {
      name                 = "appli_data_disk"
      disk_size_gb         = 512
      lun                  = 0
      storage_account_type = "Standard_LRS"
      extra_tags = {
        some_data_disk_tag = "some_data_disk_tag_value"
      }
    }
    logs_disk = {
      # Used to define Logical Unit Number (LUN) parameter
      lun          = 10
      disk_size_gb = 64
      caching      = "ReadWrite"
      extra_tags = {
        some_data_disk_tag = "some_data_disk_tag_value"
      }
    }
  }
}
```

## Providers

| Name | Version |
|------|---------|
| azapi | ~> 2.0 |
| azurecaf | ~> 1.2.28 |
| azurerm | ~> 4.26 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| azure\_region | claranet/regions/azurerm | >= 7.2.0 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource_action.main](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource_action) | resource |
| [azurerm_backup_protected_vm.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_linux_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_maintenance_assignment_virtual_machine.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_assignment_virtual_machine) | resource |
| [azurerm_managed_disk.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_monitor_data_collection_rule_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_network_interface.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_public_ip.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.rbac_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_user_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.azure_monitor_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.entra_ssh_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurecaf_name.disk](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.nic](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.pub_ip](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.vm](https://registry.terraform.io/providers/claranet/azurecaf/latest/docs/data-sources/name) | data source |
| [azurerm_managed_disk.vm_os_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_password | Password for the administrator account of the Virtual Machine. | `string` | `null` | no |
| admin\_username | Username for Virtual Machine administrator account. | `string` | n/a | yes |
| application\_gateway\_attachment | ID of the Application Gateway Backend Pool to attach the Virtual Machine to. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| availability\_set | ID of the availability set in which host the Virtual Machine. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| azure\_monitor\_agent\_auto\_upgrade\_enabled | Automatically update agent when publisher releases a new version of the agent. | `bool` | `false` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version | `string` | `"1.21"` | no |
| azure\_monitor\_data\_collection\_rule | Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` to disable. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |
| backup\_policy | Backup policy parameters from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup). | <pre>object({<br/>    id                = string<br/>    exclude_disk_luns = optional(list(number), [])<br/>  })</pre> | n/a | yes |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| computer\_name | Custom name for the Virtual Machine Hostname. `vm_name` if not set. | `string` | `""` | no |
| custom\_data | The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created. | `string` | `null` | no |
| custom\_dns\_label | The DNS label to use for public access. Virtual Machine name if not set. DNS will be `<label>.<region>.cloudapp.azure.com`. | `string` | `""` | no |
| custom\_name | Custom name for the Virtual Machine. Generated if not set. | `string` | `""` | no |
| dcr\_custom\_name | Custom name for Data collection rule association. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store boot diagnostics. | `string` | n/a | yes |
| disable\_password\_authentication | Option to disable or enable password authentication if admin password is not set. | `bool` | `true` | no |
| disk\_controller\_type | Specifies the Disk Controller Type used for this Virtual Machine. Possible values are `SCSI` and `NVMe`. | `string` | `null` | no |
| disk\_encryption\_set\_id | ID of the disk encryption set to use to encrypt VM disks. | `string` | `null` | no |
| dns\_servers | A list of IP Addresses defining the DNS Servers which should be used for this Network Interface. | `list(string)` | `null` | no |
| encryption\_at\_host\_enabled | Should all disks (including the temporary disk) attached to the Virtual Machine be encrypted by enabling Encryption at Host? [List of compatible Virtual Machine sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes). | `bool` | `true` | no |
| entra\_ssh\_login\_admin\_objects\_ids | Entra ID (aka AAD) objects IDs allowed to connect as administrator on the Virtual Machine. | `list(string)` | `[]` | no |
| entra\_ssh\_login\_enabled | Enable SSH logins with Entra ID (aka AAD). | `bool` | `false` | no |
| entra\_ssh\_login\_extension\_version | Virtual Machine extension version for Entra ID (aka AAD) SSH Login extension. | `string` | `"1.0"` | no |
| entra\_ssh\_login\_user\_objects\_ids | Entra ID (aka AAD) objects IDs allowed to connect as standard user on the Virtual Machine. | `list(string)` | `[]` | no |
| environment | Project environment. | `string` | n/a | yes |
| extensions\_extra\_tags | Extra tags to set on the VM extensions. | `map(string)` | `{}` | no |
| extra\_tags | Extra tags to set on each created resource. | `map(string)` | `{}` | no |
| identity | Map with identity block informations as described [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity). | <pre>object({<br/>    type         = string<br/>    identity_ids = list(string)<br/>  })</pre> | <pre>{<br/>  "identity_ids": [],<br/>  "type": "SystemAssigned"<br/>}</pre> | no |
| ip\_configuration\_custom\_name | Custom name for the IP config of the NIC. Generated if not set. | `string` | `null` | no |
| load\_balancer\_attachment | ID of the Load Balancer Backend Pool to attach the Virtual Machine to. | <pre>object({<br/>    id = string<br/>  })</pre> | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| maintenance\_configurations\_ids | List of maintenance configurations to attach to this VM. | `list(string)` | `[]` | no |
| monitoring\_agent\_enabled | `true` to use and deploy the Azure Monitor Agent. | `bool` | `true` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| nic\_accelerated\_networking\_enabled | Should Accelerated Networking be enabled? | `bool` | `true` | no |
| nic\_custom\_name | Custom name for the NIC interface. Generated if not set. | `string` | `null` | no |
| nic\_extra\_tags | Extra tags to set on the network interface. | `map(string)` | `{}` | no |
| os\_disk\_caching | Specifies the caching requirements for the OS Disk. | `string` | `"ReadWrite"` | no |
| os\_disk\_custom\_name | Custom name for OS disk. Generated if not set. | `string` | `null` | no |
| os\_disk\_extra\_tags | Extra tags to set on the OS disk. | `map(string)` | `{}` | no |
| os\_disk\_size\_gb | Specifies the size of the OS disk in gigabytes. | `string` | `null` | no |
| os\_disk\_storage\_account\_type | The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. | `string` | `"Premium_ZRS"` | no |
| os\_disk\_tagging\_enabled | Should OS disk tagging be enabled? Defaults to `true`. | `bool` | `true` | no |
| patch\_mode | Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`. [Compatibility list is available here](https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#supported-os-images). | `string` | `"AutomaticByPlatform"` | no |
| patching\_reboot\_setting | Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`. | `string` | `"IfRequired"` | no |
| public\_ip\_custom\_name | Custom name for Public IP. Generated if not set. | `string` | `null` | no |
| public\_ip\_enabled | Should a Public IP be attached to the Virtual Machine? | `bool` | `false` | no |
| public\_ip\_extra\_tags | Extra tags to set on the public IP resource. | `map(string)` | `{}` | no |
| public\_ip\_zones | Zones for public IP attached to the Virtual Machine. Can be `null` if no zone distpatch. | `list(number)` | <pre>[<br/>  1,<br/>  2,<br/>  3<br/>]</pre> | no |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| secure\_boot\_enabled | Specifies if Secure Boot is enabled for the Virtual Machine. Defaults to `true`. Changing this forces a new resource to be created. | `bool` | `true` | no |
| spot\_instance\_enabled | `true` to deploy Virtual Machine as a Spot Instance. | `bool` | `false` | no |
| spot\_instance\_eviction\_policy | Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is `Deallocate`. Changing this forces a new resource to be created. | `string` | `"Deallocate"` | no |
| spot\_instance\_max\_bid\_price | The maximum price you're willing to pay for this Virtual Machine in US Dollars; must be greater than the current spot price. `-1` If you don't want the Virtual Machine to be evicted for price reasons. | `number` | `-1` | no |
| ssh\_private\_key | SSH private key. | `string` | `null` | no |
| ssh\_public\_key | SSH public key. | `string` | `null` | no |
| stack | Project stack name. | `string` | n/a | yes |
| static\_private\_ip | Static private IP. Private IP is dynamic if not set. | `string` | `null` | no |
| storage\_data\_disk\_config | Map of objects to configure storage data disk(s). | <pre>map(object({<br/>    name                 = optional(string)<br/>    create_option        = optional(string, "Empty")<br/>    disk_size_gb         = number<br/>    lun                  = optional(number)<br/>    caching              = optional(string, "ReadWrite")<br/>    storage_account_type = optional(string, "StandardSSD_ZRS")<br/>    source_resource_id   = optional(string)<br/>    extra_tags           = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| subnet | ID of the Subnet where the Virtual Machine is created. | <pre>object({<br/>    id = string<br/>  })</pre> | n/a | yes |
| ultra\_ssd\_enabled | Specifies whether Ultra Disks is enabled (`UltraSSD_LRS` storage type for data disks). | `bool` | `null` | no |
| user\_data | The Base64-Encoded User Data which should be used for this Virtual Machine. | `string` | `null` | no |
| vm\_image | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined. | <pre>object({<br/>    publisher = string<br/>    offer     = string<br/>    sku       = string<br/>    version   = optional(string, "latest")<br/>  })</pre> | <pre>{<br/>  "offer": "Ubuntu",<br/>  "publisher": "Canonical",<br/>  "sku": "22_04-lts",<br/>  "version": "latest"<br/>}</pre> | no |
| vm\_image\_id | The ID of the image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not `null`. | `string` | `null` | no |
| vm\_plan | Virtual Machine plan image information. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#plan. This variable has to be used for BYOS image. Before using BYOS image, you need to accept legal plan [terms](https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az_vm_image_accept_terms). | <pre>object({<br/>    name      = string<br/>    product   = string<br/>    publisher = string<br/>  })</pre> | `null` | no |
| vm\_size | Size (SKU) of the Virtual Machine to create. | `string` | n/a | yes |
| vtpm\_enabled | Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the Virtual Machine. Defaults to `true`. Changing this forces a new resource to be created. | `bool` | `true` | no |
| zone\_id | Index of the Availability Zone which the Virtual Machine should be allocated in. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_password | Virtual Machine admin password. |
| admin\_ssh\_private\_key | Virtual Machine admin SSH private key. |
| admin\_ssh\_public\_key | Virtual Machine admin SSH public key. |
| admin\_username | Virtual Machine admin username. |
| hostname | Hostname of the Virtual Machine. |
| id | ID of the Virtual Machine. |
| identity\_principal\_id | Linux Virtual Machine system identity principal ID. |
| name | Name of the Virtual Machine. |
| nic\_id | ID of the Network Interface Configuration attached to the Virtual Machine. |
| nic\_ip\_configuration\_name | Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine. |
| nic\_name | Name of the Network Interface Configuration attached to the Virtual Machine. |
| private\_ip\_address | Private IP address of the Virtual Machine. |
| public\_domain\_name\_label | Public DNS of the Virtual Machine. |
| public\_ip\_address | Public IP address of the Virtual Machine. |
| public\_ip\_id | Public IP ID of the Virtual Machine. |
| resource | Linux Virtual Machine  resource object. |
| resource\_maintenance\_configuration\_assignment | Maintenance configuration assignment resource object. |
| resource\_os\_disk | Virtual Machine OS disk resource object. |
| resource\_public\_ip | VM Public IP resource object. |
| terraform\_module | Information about this Terraform module |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machines/linux/](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/)
