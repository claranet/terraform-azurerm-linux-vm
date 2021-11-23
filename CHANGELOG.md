# Unreleased

Changed
  * AZ-606: Remove VM Tags on disk
Added
  * AZ-608: Add variable `azure_monitor_agent_auto_upgrade_enabled`

Changed
  * AZ-608: Change provider min version to 2.83. `automatic_upgrade_enabled` option was implemented in this version in `azurerm_virtual_machine_extension`

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
