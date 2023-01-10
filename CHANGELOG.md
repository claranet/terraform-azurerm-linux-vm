# Unreleased

Added
  * GH-3: Add `vm_os_disk` output

# v7.4.0 - 2022-11-23

Changed
  * AZ-908: Use the new data source for CAF naming (instead of resource)

# v7.3.0 - 2022-11-04

Fixed
  * AZ-883: Lint code, fix deprecated HCL syntax

Added
  * AZ-894: Add `custom_computer_name` variable

# v7.2.0 - 2022-10-21

Added
  * AZ-857: Add `user_data` variable

# v7.1.0 - 2022-10-07

Added
  * AZ-858: OS disk storage tags can now be merged with existing ones using `os_disk_overwrite_tags` variable
  * AZ-864: Add `source_resource_id` parameter to support the restoration of data disks

Fixed
  * AZ-859: Add requirements for new patch management (preview)

# v7.0.0 - 2022-09-30

Breaking
  * AZ-840: Update to Terraform `1.3`

Added
  * AZ-845: Add `patch_mode` option
  * AZ-845: Set `patch_assessment_mode` to `AutomaticByPlatform` when `path_mode` is also set to `AutomaticByPlatform`

# v6.5.0 - 2022-09-16

Added
  * AZ-807: Custom name for Data Collection Rule link resource
  * AZ-818: Add RBAC option management for AAD SSH Login extension

# v6.4.0 - 2022-09-12

Changed
  * AZ-838: Change `os_disk_storage_account_type` default value to `Premium_ZRS`
  * AZ-807: Use native resource for Data Collection Rule link
  * AZ-825: Upgrade Azure Monitor agent extension (`azure_monitor_agent_version`) to latest `v1.21`

Added
  * AZ-825: Add tags on deployed VM extensions and add `extensions_extra_tags` parameter

# v6.3.1 - 2022-08-19

Fixed
  * AZ-828: Bump `vm_os_disk_tagging` module to latest `v4.0.2`

# v6.3.0 - 2022-08-05

Added
  * AZ-814: Add backup option
  * AZ-818: Add Azure Active Directory Login capability

# v6.2.0 - 2022-07-29

Fixed
  * AZ-717: Bump legacy `vm-logs` module to latest `v4.2.0`

# v6.1.0 - 2022-06-24

Added
  * AZ-770: Add Terraform module info in output

# v6.0.0 - 2022-05-16

Breaking
  * AZ-717: Update module for AzureRM provider `v3.0`

# v5.1.0 - 2022-02-18

Added
  * AZ-615: Add an option to enable or disable default tags

Changed
  * AZ-614: Optional OS disk tagging

# v5.0.0 - 2022-01-13

Breaking
  * AZ-515: Option to use Azure CAF naming provider to name resources

# v4.3.0 - 2021-11-24

Added
  * AZ-608: Add variable `azure_monitor_agent_auto_upgrade_enabled`

Changed
  * AZ-606: Remove VM Tags on data attached disks
  * AZ-608: Change Azure provider minimum version to `v2.83`. `automatic_upgrade_enabled` option was implemented by this provider version in `azurerm_virtual_machine_extension` resource

# v4.2.0 - 2021-10-18

Breaking
  * AZ-302: Replace diagnostics agent with Azure Monitor agent

Added
  * AZ-487: Manage user managed identity for the virtual machine
  * AZ-576: Allow deploying Spot Instances

Changed
  * AZ-302: Bump Log Analytics version to latest and allow override
  * AZ-572: Revamp examples and improve CI

# v4.1.2 - 2021-08-20

Changed
  * AZ-532: Revamp README with latest `terraform-docs` tool
  * AZ-530: Cleanup module and fix linter errors

# v4.1.1 - 2021-02-26

Fixed
  * AZ-451: set `zone_id` as optional

# v4.1.0 - 2021-01-08

Fixed
  * AZ-403: Fix `storage_data_disk` variable definition
  * AZ-413: Unable to use `source_image_id` (conflict with `source_image_reference`)

Changed
  * AZ-398: Force lowercase on default generated name
  * AZ-414: Management of plan for BYOS virtual machine images

Added
  * AZ-398: Add `name_prefix` variable for generated name
  * AZ-414: Add `plan` variable for BYOS virtual machine images (including `name`, `product` and `publisher`)

# v3.3.1/v4.0.0 - 2020-11-19

Updated
  * AZ-273: Module now compatible terraform `v0.13+`

# v3.3.0 - 2020-11-17

Added
  * AZ-325: Add System Identity to virtual machine
  * AZ-346: Add specific tags for each data disks
  * AZ-323: Allow use of osdisk custom name

# v3.2.0 - 2020-10-16

Added
  * AZ-319: add specific tags for nic, data disk and pub ip

# v3.1.0 - 2020-08-27

Added
  * AZ-261: Add ability to set password authentication

# v3.0.1 - 2020-08-24

Fixed
  * AZ-257: Fix unused `custom_data` variable

# v3.0.0 - 2020-07-29

Breaking
  * AZ-189: Upgrading module to be compliant to AzureRM 2.0+. It now uses `azurerm_linux_virtual_machine` terraform resource

# v2.4.0 - 2020-07-22

Changed
  * AZ-223: Upgrade version of vm-logs module

Added
  * AZ-210: Enable unmanaged disk configuration
  * AZ-234: Add option to force Static private IP
  * AZ-234: Add option to assoc Network Security Group to the NIC
  * AZ-234: Output NIC ID

Fixed
  * AZ-167: Fix NIC configuration name

# v2.3.0 - 2020-07-03

Fixed
  * AZ-180: Apply OS tags only on VM resource

Added
  * AZ-214: Support for `custom_data` parameter in `os_profile` block
  * AZ-222: Option to activate `enable_accelerated_networking` on NIC resource

# v2.2.0 - 2020-02-14

Added
  * AZ-174: Add Availability Zone option
  * AZ-173: Allow to configure disk size and type
  * AZ-108: Linux-VM enable diagnostics
  * AZ-180: Additional default tags

# v2.1.0 - 2020-01-07

Added
  * AZ-167: Allow to change IP sku and attach to a Load Balancer or Application Gateway

# v2.0.2 - 2019-11-22

Changed
  * AZ-118: Cleanup and update README/variables

# v2.0.1 - 2019-11-14

Added
  * AZ-142: Prepare publishing on Terraform registry

# v2.0.0 - 2019-11-14

Added
  * AZ-108: First release
