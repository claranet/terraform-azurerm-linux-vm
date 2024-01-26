variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming."
  type        = string
}

variable "environment" {
  description = "Project environment."
  type        = string
}

variable "stack" {
  description = "Project stack name."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name."
  type        = string
}

variable "admin_username" {
  description = "Username for Virtual Machine administrator account."
  type        = string
}

### Password authentication
variable "admin_password" {
  description = "Password for the administrator account of the virtual machine."
  type        = string
  default     = null
}

### SSH Connection inputs
variable "ssh_public_key" {
  description = "SSH public key."
  type        = string
  default     = null
}

variable "ssh_private_key" {
  description = "SSH private key."
  type        = string
  default     = null
}

### Network inputs
variable "subnet_id" {
  description = "ID of the Subnet in which create the Virtual Machine."
  type        = string
}

variable "nic_enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to `false`."
  type        = bool
  default     = false
}

variable "nic_nsg_id" {
  description = "NSG ID to associate on the Network Interface. No association if null."
  type        = string
  default     = null
}

variable "static_private_ip" {
  description = "Static private IP. Private IP is dynamic if not set."
  type        = string
  default     = null
}

### VM inputs
variable "custom_data" {
  description = "The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

variable "user_data" {
  description = "The Base64-Encoded User Data which should be used for this Virtual Machine."
  type        = string
  default     = null
}

variable "vm_size" {
  description = "Size (SKU) of the Virtual Machine to create."
  type        = string
}

variable "availability_set_id" {
  description = "Id of the availability set in which host the Virtual Machine."
  type        = string
  default     = null
}

variable "zone_id" {
  description = "Index of the Availability Zone which the Virtual Machine should be allocated in."
  type        = number
  default     = null
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined."
  type        = map(string)

  default = {
    publisher = "Debian"
    offer     = "debian-10"
    sku       = "10"
    version   = "latest"
  }
}

variable "vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not null."
  type        = string
  default     = null
}

variable "vm_plan" {
  description = "Virtual Machine plan image information. See https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#plan. This variable has to be used for BYOS image. Before using BYOS image, you need to accept legal plan terms. See https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az_vm_image_accept_terms."
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  default = null
}

variable "storage_data_disk_config" {
  description = "Map of objects to configure storage data disk(s)."
  type = map(object({
    name                 = optional(string)
    create_option        = optional(string, "Empty")
    disk_size_gb         = number
    lun                  = optional(number)
    caching              = optional(string, "ReadWrite")
    storage_account_type = optional(string, "StandardSSD_ZRS")
    source_resource_id   = optional(string)
    extra_tags           = optional(map(string), {})
  }))
  default = {}
}

variable "custom_dns_label" {
  description = "The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com."
  type        = string
  default     = ""
}

variable "public_ip_sku" {
  description = "SKU for the public IP attached to the VM. Can be `null` if no public IP needed."
  type        = string
  default     = "Standard"
}

variable "public_ip_zones" {
  description = "Zones for public IP attached to the VM. Can be `null` if no zone distpatch."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "attach_load_balancer" {
  description = "True to attach this VM to a Load Balancer."
  type        = bool
  default     = false
}

variable "load_balancer_backend_pool_id" {
  description = "Id of the Load Balancer Backend Pool to attach the VM."
  type        = string
  default     = null
}

variable "attach_application_gateway" {
  description = "True to attach this VM to an Application Gateway."
  type        = bool
  default     = false
}

variable "application_gateway_backend_pool_id" {
  description = "Id of the Application Gateway Backend Pool to attach the VM."
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Specifies the size of the OS disk in gigabytes."
  type        = string
  default     = null
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`."
  type        = string
  default     = "Premium_ZRS"
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk."
  type        = string
  default     = "ReadWrite"
}

variable "encryption_at_host_enabled" {
  description = "Should all disks (including the temporary disk) attached to the Virtual Machine be encrypted by enabling Encryption at Host? List of compatible VM sizes: https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes."
  type        = bool
  default     = false
}

## Identity variables
variable "identity" {
  description = "Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity."
  type = object({
    type         = string
    identity_ids = list(string)
  })
  default = {
    type         = "SystemAssigned"
    identity_ids = []
  }
}

## Spot variables
variable "spot_instance" {
  description = "True to deploy VM as a Spot Instance"
  type        = bool
  default     = false
}

variable "spot_instance_max_bid_price" {
  description = "The maximum price you're willing to pay for this VM in US Dollars; must be greater than the current spot price. `-1` If you don't want the VM to be evicted for price reasons."
  type        = number
  default     = -1
}

variable "spot_instance_eviction_policy" {
  description = "Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is `Deallocate`. Changing this forces a new resource to be created."
  type        = string
  default     = "Deallocate"
}

## Backup variable
variable "backup_policy_id" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup)."
  type        = string
}

## Patching variables
variable "patch_mode" {
  description = "Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`. Compatibility list is available here https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#supported-os-images."
  type        = string
  default     = "ImageDefault"
}

variable "maintenance_configuration_ids" {
  description = "List of maintenance configurations to attach to this VM."
  type        = list(string)
  default     = []
}

variable "patching_reboot_setting" {
  description = "Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`."
  type        = string
  default     = "IfRequired"
  nullable    = false
}
