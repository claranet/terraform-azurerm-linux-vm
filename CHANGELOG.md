# v3.2.0 - Unreleased

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
