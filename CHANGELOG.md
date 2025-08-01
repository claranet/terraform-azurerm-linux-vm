## 8.5.0 (2025-07-11)

### Features

* **AZ-1581:** allow to exclude disks from backup aa138a6
* **AZ-1582:** add Premiumv2_LRS/UltraSSD_LRS disk support a0bf408

### Miscellaneous Chores

* **⚙️:** ✏️ update template identifier for MR review a4edd4d
* 🗑️ remove old commitlint configuration files 80dd85e
* **deps:** update dependency opentofu to v1.10.0 f84840a
* **deps:** update dependency opentofu to v1.10.1 89be453
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.1 8105ab9
* **deps:** update tools 34b5658

## 8.4.0 (2025-06-06)

### Features

* ✨ remove `vm_agent_platform_updates_enabled` variable 35600c7

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.9.1 88b2da7
* **deps:** update dependency terraform-docs to v0.20.0 bc2a018
* **deps:** update dependency tflint to v0.57.0 7811db7
* **deps:** update dependency tflint to v0.58.0 9afcd82
* **deps:** update dependency trivy to v0.61.1 79de588
* **deps:** update dependency trivy to v0.62.0 e4c7c7f
* **deps:** update dependency trivy to v0.62.1 a77c500
* **deps:** update dependency trivy to v0.63.0 8f2ca73
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.2.0 eeaed45
* **deps:** update tools a7a3cce

## 8.3.0 (2025-03-21)

### Features

* **AZ-1539:** adding dns-servers option for nic da4ae6e

### Miscellaneous Chores

* **deps:** update dependency pre-commit to v4.2.0 1a27711
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.22.0 00cc87d

## 8.2.0 (2025-03-07)

### Features

* **AZ-1533:** add `disk_encryption_set_id` option 36ca5d8

### Miscellaneous Chores

* **deps:** update dependency trivy to v0.60.0 6f17740

## 8.1.0 (2025-02-21)

### Features

* **AZ-1518:** add security boot option c4ce539

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.9.0 df09ddd
* **deps:** update dependency pre-commit to v4.1.0 8893ca4
* **deps:** update dependency tflint to v0.55.0 d367a03
* **deps:** update dependency trivy to v0.58.2 3fea51c
* **deps:** update dependency trivy to v0.59.1 1076f09
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.21.0 b8f5b0c
* **deps:** update tools e2c3bf3
* update Github templates 2709e73
* update tflint config for v0.55.0 cc71c45

## 8.0.0 (2025-01-03)

### ⚠ BREAKING CHANGES

* **AZ-1088:** AzureRM Provider v4+ and OpenTofu 1.8+

### Features

* **AZ-1088:** add missing `linux-vm` parameters e39224f
* **AZ-1088:** apply suggestions bb0c862
* **AZ-1088:** apply suggestions 560a893
* **AZ-1088:** module v8 structure and updates 10457e6
* use `azapi` to apply tag on OS Disk 1861916

### Bug Fixes

* body for AzAPI v2+ c22fa19

### Documentation

* update examples 444f7ca

### Code Refactoring

* **AZ-1088:** apply suggestions acbf51d
* **AZ-1088:** apply updates suggestions 38b7e0c
* **AZ-1088:** apply variable naming suggestions 971297c

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.6 5008d78
* **deps:** update dependency opentofu to v1.8.8 dc15b73
* **deps:** update dependency trivy to v0.58.1 260f602
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.19.0 10fbda5
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.20.0 d9bf3b9
* **deps:** update tools cf6b721
* drop `nic_nsg`, should be handled out of this module 105b34a
* **trivy:** add ignore file 6f66c86

## 7.13.0 (2024-11-22)

### Features

* **AZ-1484:** add `disable_password_authentication` variable de90ad5

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.8.3 a971b99
* **deps:** update dependency opentofu to v1.8.4 5311eb4
* **deps:** update dependency pre-commit to v4 70c534d
* **deps:** update dependency pre-commit to v4.0.1 4995561
* **deps:** update dependency tflint to v0.54.0 5d9ae3e
* **deps:** update dependency trivy to v0.56.0 add328c
* **deps:** update dependency trivy to v0.56.1 880927e
* **deps:** update dependency trivy to v0.56.2 11d580c
* **deps:** update dependency trivy to v0.57.1 0045797
* **deps:** update pre-commit hook pre-commit/pre-commit-hooks to v5 86a08a5
* **deps:** update pre-commit hook tofuutils/pre-commit-opentofu to v2.1.0 995ab1d
* **deps:** update terraform claranet/tagging/azurerm to v6.0.2 50bf166
* **deps:** update tools 9c9896f
* prepare for new examples structure ad6ceed
* update examples structure fa75738

## 7.12.0 (2024-10-03)

### Features

* use Claranet "azurecaf" provider b2aa1bf

### Documentation

* update README badge to use OpenTofu registry 8676b51
* update README with `terraform-docs` v0.19.0 f29b61c

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.3 deac061
* **deps:** update dependency opentofu to v1.8.0 13c9af7
* **deps:** update dependency opentofu to v1.8.1 7a3b7ad
* **deps:** update dependency opentofu to v1.8.2 5364ce0
* **deps:** update dependency pre-commit to v3.8.0 a6049f8
* **deps:** update dependency tflint to v0.51.2 be1d227
* **deps:** update dependency tflint to v0.52.0 3a8ff08
* **deps:** update dependency tflint to v0.53.0 1a54790
* **deps:** update dependency trivy to v0.53.0 06c4108
* **deps:** update dependency trivy to v0.54.1 7a73385
* **deps:** update dependency trivy to v0.55.0 be286a4
* **deps:** update dependency trivy to v0.55.1 d1fcaf8
* **deps:** update dependency trivy to v0.55.2 b0a78cb
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.17.0 9c2ed5b
* **deps:** update pre-commit hook alessandrojcm/commitlint-pre-commit-hook to v9.18.0 9c48eb5
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.1 22384b7
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.2 2aff41d
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.3 2eb2b50
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.93.0 7f25e1f
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.0 c93a09e
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.1 5adbfba
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.2 5f41807
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.94.3 4408391
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.95.0 816b949
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.96.0 71ce53a
* **deps:** update terraform claranet/regions/azurerm to ~> 7.2.0 9c41e83
* **deps:** update tools 16cd182

## 7.11.2 (2024-06-21)


### ⚠ BREAKING CHANGES

* changes introduced with AzureRM provider `v3.108.0`

### Code Refactoring

* rename `nic_enable_accelerated_networking` to `nic_accelerated_networking_enabled` e5ac9ec

### Miscellaneous Chores

* **deps:** update dependency opentofu to v1.7.0 25158a6
* **deps:** update dependency opentofu to v1.7.1 e28f269
* **deps:** update dependency opentofu to v1.7.2 f73573a
* **deps:** update dependency pre-commit to v3.7.1 13af187
* **deps:** update dependency terraform-docs to v0.18.0 76e480a
* **deps:** update dependency tflint to v0.51.0 2153a3b
* **deps:** update dependency tflint to v0.51.1 66e97e8
* **deps:** update dependency trivy to v0.50.4 66c5d63
* **deps:** update dependency trivy to v0.51.0 f34b499
* **deps:** update dependency trivy to v0.51.1 db20141
* **deps:** update dependency trivy to v0.51.2 6b5add5
* **deps:** update dependency trivy to v0.51.4 6c59592
* **deps:** update dependency trivy to v0.52.0 655f4f9
* **deps:** update dependency trivy to v0.52.1 f263027
* **deps:** update dependency trivy to v0.52.2 63ec743
* **deps:** update pre-commit hook antonbabenko/pre-commit-terraform to v1.92.0 014eba5

## 7.11.1 (2024-04-26)


### Styles

* **output:** remove unused version from outputs-module 7e04785


### Continuous Integration

* **AZ-1391:** enable semantic-release [skip ci] 7e9cae0
* **AZ-1391:** update semantic-release config [skip ci] b2ffdd0


### Miscellaneous Chores

* **deps:** add renovate.json 0992e9b
* **deps:** enable automerge on renovate abfd8f8
* **deps:** update dependency trivy to v0.50.2 a0ca024
* **deps:** update renovate.json 2dd2ee7
* **deps:** update terraform claranet/regions/azurerm to v7 73b15ac
* **pre-commit:** update commitlint hook e303866
* **release:** remove legacy `VERSION` file 4507caa

# v7.11.0 - 2024-02-02

Added
  * AZ-1342: Add `encryption_at_host_enabled` parameter

# v7.10.0 - 2023-09-15

Changed
  * AZ-1052: Disable legacy log agent by default
  * AZ-1052: Improved legacy agent configuration

# v7.9.0 - 2023-09-08

Changed
  * AZ-1165: Change `bypass_platform_safety_checks_on_user_schedule_enabled` implementation from azapi provider to native azurerm

# v7.8.1 - 2023-06-16

Fixed
  * AZ-1102: Fix the managed data disks zone parameter if the storage type is `ZRS`

# v7.8.0 - 2023-05-26

Added
  * AZ-1080: Added `bypassPlatformSafetyChecksOnUserSchedule` when `patch_mode` is `AutomaticByPlatform`.

Changed
  * AZ-1080: The `Azure-Region` Claranet module is now included.

# v7.7.0 - 2023-03-03

Changed
  * AZ-1019: Bump `os_tagging` module
  * AZ-1017: Added `name_suffix` to storage disk default naming

# v7.6.0 - 2023-02-03

Added
  * AZ-837: Add maintenance configuration attachment option

# v7.5.0 - 2023-01-13

Added
  * [GH-3](https://github.com/claranet/terraform-azurerm-linux-vm/pull/3): Add `vm_os_disk` output

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
