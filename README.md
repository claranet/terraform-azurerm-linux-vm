# Azure Linux Virtual Machine

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/claranet/linux-vm/azurerm/)

This module creates a [Linux Virtual Machine](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/).

Following tags are automatically set with default values: `env`, `stack`, `os_family`, `os_distribution`, `os_version`.

## Requirements

* [Microsoft.Compute/InGuestAutoAssessmentVMPreview](https://learn.microsoft.com/en-us/azure/update-center/enable-machines?tabs=portal-periodic) must be activated on the subscription to use `patch_mode = "AutomaticByPlatform"` patching option.

<!-- BEGIN_TF_DOCS -->
## Global versioning rule for Claranet Azure modules

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 7.x.x       | 1.3.x             | >= 3.0          |
| >= 6.x.x       | 1.x               | >= 3.0          |
| >= 5.x.x       | 0.15.x            | >= 2.0          |
| >= 4.x.x       | 0.13.x / 0.14.x   | >= 2.0          |
| >= 3.x.x       | 0.12.x            | >= 2.0          |
| >= 2.x.x       | 0.12.x            | < 2.0           |
| <  2.x.x       | 0.11.x            | < 2.0           |

## Contributing

If you want to contribute to this repository, feel free to use our [pre-commit](https://pre-commit.com/) git hook configuration
which will help you automatically update and format some files for you by enforcing our Terraform code module best-practices.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

This module is optimized to work with the [Claranet terraform-wrapper](https://github.com/claranet/terraform-wrapper) tool
which set some terraform variables in the environment needed by this module.
More details about variables set by the `terraform-wrapper` available in the [documentation](https://github.com/claranet/terraform-wrapper#environment).

```hcl
module "azure_region" {
  source  = "claranet/regions/azurerm"
  version = "x.x.x"

  azure_region = var.azure_region
}

module "rg" {
  source  = "claranet/rg/azurerm"
  version = "x.x.x"

  location    = module.azure_region.location
  client_name = var.client_name
  environment = var.environment
  stack       = var.stack
}

module "azure_network_vnet" {
  source  = "claranet/vnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location       = module.azure_region.location
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name = module.rg.resource_group_name
  vnet_cidr           = ["10.10.0.0/16"]
}

module "azure_network_subnet" {
  source  = "claranet/subnet/azurerm"
  version = "x.x.x"

  environment    = var.environment
  location_short = module.azure_region.location_short
  client_name    = var.client_name
  stack          = var.stack

  resource_group_name  = module.rg.resource_group_name
  virtual_network_name = module.azure_network_vnet.virtual_network_name
  subnet_cidr_list     = ["10.10.10.0/24"]

  route_table_name = module.azure_network_route_table.route_table_name

  network_security_group_name = module.network_security_group.network_security_group_name
}

module "network_security_group" {
  source  = "claranet/nsg/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
}

module "azure_network_route_table" {
  source  = "claranet/route-table/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name
}

resource "azurerm_availability_set" "vm_avset" {
  name                = "${var.stack}-${var.client_name}-${module.azure_region.location_short}-${var.environment}-as"
  location            = module.azure_region.location
  resource_group_name = module.rg.resource_group_name
  managed             = true
}

module "run" {
  source  = "claranet/run/azurerm"
  version = "x.x.x"

  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  resource_group_name = module.rg.resource_group_name

  monitoring_function_enabled = false
  vm_monitoring_enabled       = true
  backup_vm_enabled           = true
  update_center_enabled       = true

  update_center_periodic_assessment_enabled = true
  update_center_periodic_assessment_scopes  = [module.rg.resource_group_id]
  update_center_maintenance_configurations = [
    {
      configuration_name = "Donald"
      start_date_time    = "2021-08-21 04:00"
      recur_every        = "1Day"
    },
    {
      configuration_name = "Hammer"
      start_date_time    = "1900-01-01 03:00"
      recur_every        = "1Week"
    }
  ]

  recovery_vault_cross_region_restore_enabled = true
  vm_backup_daily_policy_retention            = 31
}

module "vm" {
  source  = "claranet/linux-vm/azurerm"
  version = "x.x.x"

  location            = module.azure_region.location
  location_short      = module.azure_region.location_short
  client_name         = var.client_name
  environment         = var.environment
  stack               = var.stack
  resource_group_name = module.rg.resource_group_name

  subnet_id      = module.azure_network_subnet.subnet_id
  vm_size        = "Standard_B2s"
  admin_username = var.vm_administrator_login
  ssh_public_key = var.ssh_public_key

  diagnostics_storage_account_name      = module.run.logs_storage_account_name
  azure_monitor_data_collection_rule_id = module.run.data_collection_rule_id

  # Set to null to deactivate backup
  backup_policy_id = module.run.vm_backup_policy_id

  patch_mode                    = "AutomaticByPlatform"
  maintenance_configuration_ids = [module.run.maintenance_configurations["Donald"].id, module.run.maintenance_configurations["Hammer"].id]

  availability_set_id = azurerm_availability_set.vm_avset.id
  # or use Availability Zone
  # zone_id = 1

  vm_image = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
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
| azurecaf | ~> 1.2, >= 1.2.22 |
| azurerm | ~> 3.67 |
| null | ~> 3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| azure\_region | claranet/regions/azurerm | ~> 6.1.0 |
| vm\_logs | claranet/vm-logs/azurerm | 4.2.0 |
| vm\_os\_disk\_tagging | claranet/tagging/azurerm | 6.0.1 |

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_protected_vm.backup](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_maintenance_assignment_virtual_machine.maintenance_configurations](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/maintenance_assignment_virtual_machine) | resource |
| [azurerm_managed_disk.disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_monitor_data_collection_rule_association.dcr](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_data_collection_rule_association) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_network_interface_application_gateway_backend_address_pool_association.appgw_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_application_gateway_backend_address_pool_association) | resource |
| [azurerm_network_interface_backend_address_pool_association.lb_pool_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association) | resource |
| [azurerm_network_interface_security_group_association.nic_nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_security_group_association) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_role_assignment.rbac_admin_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.rbac_user_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_virtual_machine_data_disk_attachment.data_disk_attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.aad_ssh_login](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.azure_monitor_agent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.log_extension](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [null_resource.fake_vm_logs_condition](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurecaf_name.disk](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.nic](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.pub_ip](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurecaf_name.vm](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/data-sources/name) | data source |
| [azurerm_managed_disk.vm_os_disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/managed_disk) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aad\_ssh\_login\_admin\_objects\_ids | Azure Active Directory objects IDs allowed to connect as administrator on the VM. | `list(string)` | `[]` | no |
| aad\_ssh\_login\_enabled | Enable SSH logins with Azure Active Directory | `bool` | `false` | no |
| aad\_ssh\_login\_extension\_version | VM Extension version for Azure Active Directory SSH Login extension | `string` | `"1.0"` | no |
| aad\_ssh\_login\_user\_objects\_ids | Azure Active Directory objects IDs allowed to connect as standard user on the VM. | `list(string)` | `[]` | no |
| admin\_password | Password for the administrator account of the virtual machine. | `string` | `null` | no |
| admin\_username | Username for Virtual Machine administrator account. | `string` | n/a | yes |
| application\_gateway\_backend\_pool\_id | Id of the Application Gateway Backend Pool to attach the VM. | `string` | `null` | no |
| attach\_application\_gateway | True to attach this VM to an Application Gateway. | `bool` | `false` | no |
| attach\_load\_balancer | True to attach this VM to a Load Balancer. | `bool` | `false` | no |
| availability\_set\_id | Id of the availability set in which host the Virtual Machine. | `string` | `null` | no |
| azure\_monitor\_agent\_auto\_upgrade\_enabled | Automatically update agent when publisher releases a new version of the agent. | `bool` | `false` | no |
| azure\_monitor\_agent\_version | Azure Monitor Agent extension version | `string` | `"1.21"` | no |
| azure\_monitor\_data\_collection\_rule\_id | Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` if legacy agent is used. | `string` | n/a | yes |
| backup\_policy\_id | Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup). | `string` | n/a | yes |
| client\_name | Client name/account used in naming. | `string` | n/a | yes |
| custom\_computer\_name | Custom name for the Virtual Machine Hostname. `vm_name` if not set. | `string` | `""` | no |
| custom\_data | The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created. | `string` | `null` | no |
| custom\_dcr\_name | Custom name for Data collection rule association | `string` | `null` | no |
| custom\_dns\_label | The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com. | `string` | `""` | no |
| custom\_ipconfig\_name | Custom name for the IP config of the NIC. Generated if not set. | `string` | `null` | no |
| custom\_name | Custom name for the Virtual Machine. Generated if not set. | `string` | `""` | no |
| custom\_nic\_name | Custom name for the NIC interface. Generated if not set. | `string` | `null` | no |
| custom\_public\_ip\_name | Custom name for public IP. Generated if not set. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| diagnostics\_storage\_account\_name | Name of the Storage Account in which store boot diagnostics and for legacy monitoring agent. | `string` | n/a | yes |
| diagnostics\_storage\_account\_sas\_token | SAS token of the Storage Account in which store vm diagnostics. Used only with legacy monitoring agent, set to `null` if not needed. | `string` | `null` | no |
| encryption\_at\_host\_enabled | Should all disks (including the temporary disk) attached to the Virtual Machine be encrypted by enabling Encryption at Host? List of compatible VM sizes: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes. | `bool` | `false` | no |
| environment | Project environment. | `string` | n/a | yes |
| extensions\_extra\_tags | Extra tags to set on the VM extensions. | `map(string)` | `{}` | no |
| extra\_tags | Extra tags to set on each created resource. | `map(string)` | `{}` | no |
| identity | Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity. | <pre>object({<br>    type         = string<br>    identity_ids = list(string)<br>  })</pre> | <pre>{<br>  "identity_ids": [],<br>  "type": "SystemAssigned"<br>}</pre> | no |
| load\_balancer\_backend\_pool\_id | Id of the Load Balancer Backend Pool to attach the VM. | `string` | `null` | no |
| location | Azure location. | `string` | n/a | yes |
| location\_short | Short string for Azure location. | `string` | n/a | yes |
| log\_analytics\_agent\_enabled | Deploy Log Analytics VM extension - depending of OS (cf. https://docs.microsoft.com/fr-fr/azure/azure-monitor/agents/agents-overview#linux) | `bool` | `false` | no |
| log\_analytics\_agent\_version | Azure Log Analytics extension version. | `string` | `"1.14"` | no |
| log\_analytics\_workspace\_guid | GUID of the Log Analytics Workspace to link with. | `string` | `null` | no |
| log\_analytics\_workspace\_key | Access key of the Log Analytics Workspace to link with. | `string` | `null` | no |
| maintenance\_configuration\_ids | List of maintenance configurations to attach to this VM. | `list(string)` | `[]` | no |
| name\_prefix | Optional prefix for the generated name. | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name. | `string` | `""` | no |
| nic\_enable\_accelerated\_networking | Should Accelerated Networking be enabled? Defaults to `false`. | `bool` | `false` | no |
| nic\_extra\_tags | Extra tags to set on the network interface. | `map(string)` | `{}` | no |
| nic\_nsg\_id | NSG ID to associate on the Network Interface. No association if null. | `string` | `null` | no |
| os\_disk\_caching | Specifies the caching requirements for the OS Disk. | `string` | `"ReadWrite"` | no |
| os\_disk\_custom\_name | Custom name for OS disk. Generated if not set. | `string` | `null` | no |
| os\_disk\_extra\_tags | Extra tags to set on the OS disk. | `map(string)` | `{}` | no |
| os\_disk\_overwrite\_tags | True to overwrite existing OS disk tags instead of merging. | `bool` | `false` | no |
| os\_disk\_size\_gb | Specifies the size of the OS disk in gigabytes. | `string` | `null` | no |
| os\_disk\_storage\_account\_type | The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. | `string` | `"Premium_ZRS"` | no |
| os\_disk\_tagging\_enabled | Should OS disk tagging be enabled? Defaults to `true`. | `bool` | `true` | no |
| patch\_mode | Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`. Compatibility list is available here https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#supported-os-images. | `string` | `"ImageDefault"` | no |
| patching\_reboot\_setting | Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`. | `string` | `"IfRequired"` | no |
| public\_ip\_extra\_tags | Extra tags to set on the public IP resource. | `map(string)` | `{}` | no |
| public\_ip\_sku | SKU for the public IP attached to the VM. Can be `null` if no public IP needed. | `string` | `"Standard"` | no |
| public\_ip\_zones | Zones for public IP attached to the VM. Can be `null` if no zone distpatch. | `list(number)` | <pre>[<br>  1,<br>  2,<br>  3<br>]</pre> | no |
| resource\_group\_name | Resource group name. | `string` | n/a | yes |
| spot\_instance | True to deploy VM as a Spot Instance | `bool` | `false` | no |
| spot\_instance\_eviction\_policy | Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is `Deallocate`. Changing this forces a new resource to be created. | `string` | `"Deallocate"` | no |
| spot\_instance\_max\_bid\_price | The maximum price you're willing to pay for this VM in US Dollars; must be greater than the current spot price. `-1` If you don't want the VM to be evicted for price reasons. | `number` | `-1` | no |
| ssh\_private\_key | SSH private key. | `string` | `null` | no |
| ssh\_public\_key | SSH public key. | `string` | `null` | no |
| stack | Project stack name. | `string` | n/a | yes |
| static\_private\_ip | Static private IP. Private IP is dynamic if not set. | `string` | `null` | no |
| storage\_data\_disk\_config | Map of objects to configure storage data disk(s). | <pre>map(object({<br>    name                 = optional(string)<br>    create_option        = optional(string, "Empty")<br>    disk_size_gb         = number<br>    lun                  = optional(number)<br>    caching              = optional(string, "ReadWrite")<br>    storage_account_type = optional(string, "StandardSSD_ZRS")<br>    source_resource_id   = optional(string)<br>    extra_tags           = optional(map(string), {})<br>  }))</pre> | `{}` | no |
| subnet\_id | ID of the Subnet in which create the Virtual Machine. | `string` | n/a | yes |
| use\_caf\_naming | Use the Azure CAF naming provider to generate default resource name. `custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| use\_legacy\_monitoring\_agent | True to use the legacy monitoring agent instead of Azure Monitor Agent. | `bool` | `false` | no |
| user\_data | The Base64-Encoded User Data which should be used for this Virtual Machine. | `string` | `null` | no |
| vm\_image | Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined. | `map(string)` | <pre>{<br>  "offer": "debian-10",<br>  "publisher": "Debian",<br>  "sku": "10",<br>  "version": "latest"<br>}</pre> | no |
| vm\_image\_id | The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null. | `string` | `null` | no |
| vm\_plan | Virtual Machine plan image information. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#plan. This variable has to be used for BYOS image. Before using BYOS image, you need to accept legal plan terms. See https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az_vm_image_accept_terms. | <pre>object({<br>    name      = string<br>    product   = string<br>    publisher = string<br>  })</pre> | `null` | no |
| vm\_size | Size (SKU) of the Virtual Machine to create. | `string` | n/a | yes |
| zone\_id | Index of the Availability Zone which the Virtual Machine should be allocated in. | `number` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| maintenance\_configurations\_assignments | Maintenance configurations assignments configurations. |
| terraform\_module | Information about this Terraform module |
| vm\_admin\_password | Virtual Machine admin password |
| vm\_admin\_ssh\_private\_key | Virtual Machine admin SSH private key |
| vm\_admin\_ssh\_public\_key | Virtual Machine admin SSH public key |
| vm\_admin\_username | Virtual Machine admin username |
| vm\_hostname | Hostname of the Virtual Machine |
| vm\_id | ID of the Virtual Machine |
| vm\_identity | Identity block with principal ID |
| vm\_name | Name of the Virtual Machine |
| vm\_nic\_id | ID of the Network Interface Configuration attached to the Virtual Machine |
| vm\_nic\_ip\_configuration\_name | Name of the IP Configuration for the Network Interface Configuration attached to the Virtual Machine |
| vm\_nic\_name | Name of the Network Interface Configuration attached to the Virtual Machine |
| vm\_os\_disk | Virtual Machine OS disk |
| vm\_private\_ip\_address | Private IP address of the Virtual Machine |
| vm\_public\_domain\_name\_label | Public DNS of the Virtual machine |
| vm\_public\_ip\_address | Public IP address of the Virtual Machine |
| vm\_public\_ip\_id | Public IP ID of the Virtual Machine |
<!-- END_TF_DOCS -->

## Related documentation

Microsoft Azure documentation: [docs.microsoft.com/en-us/azure/virtual-machines/linux/](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/)
