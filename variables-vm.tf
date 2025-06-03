variable "admin_username" {
  description = "Username for Virtual Machine administrator account."
  type        = string
}

### Password authentication
variable "admin_password" {
  description = "Password for the administrator account of the Virtual Machine."
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
variable "subnet" {
  description = "ID of the Subnet where the Virtual Machine is created."
  type = object({
    id = string
  })
  nullable = false
}

variable "nic_accelerated_networking_enabled" {
  description = "Should Accelerated Networking be enabled?"
  type        = bool
  default     = true
}

variable "static_private_ip" {
  description = "Static private IP. Private IP is dynamic if not set."
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "A list of IP Addresses defining the DNS Servers which should be used for this Network Interface."
  type        = list(string)
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

variable "availability_set" {
  description = "ID of the availability set in which host the Virtual Machine."
  type = object({
    id = string
  })
  default = null
}

variable "zone_id" {
  description = "Index of the Availability Zone which the Virtual Machine should be allocated in."
  type        = number
  default     = null
}

variable "vm_image" {
  description = "Virtual Machine source image information. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#storage_image_reference. This variable cannot be used if `vm_image_id` is already defined."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = optional(string, "latest")
  })
  default = {
    publisher = "Canonical"
    offer     = "Ubuntu"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

variable "vm_image_id" {
  description = "The ID of the image which this Virtual Machine should be created from. This variable supersedes the `vm_image` variable if not `null`."
  type        = string
  default     = null
}

variable "vm_plan" {
  description = "Virtual Machine plan image information. See [documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#plan. This variable has to be used for BYOS image. Before using BYOS image, you need to accept legal plan [terms](https://docs.microsoft.com/en-us/cli/azure/vm/image?view=azure-cli-latest#az_vm_image_accept_terms)."
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
  default  = {}
  nullable = false
}

variable "custom_dns_label" {
  description = "The DNS label to use for public access. Virtual Machine name if not set. DNS will be `<label>.<region>.cloudapp.azure.com`."
  type        = string
  default     = ""
}

variable "public_ip_enabled" {
  description = "Should a Public IP be attached to the Virtual Machine?"
  type        = bool
  default     = false
  nullable    = false
}

variable "public_ip_zones" {
  description = "Zones for public IP attached to the Virtual Machine. Can be `null` if no zone distpatch."
  type        = list(number)
  default     = [1, 2, 3]
}

variable "load_balancer_attachment" {
  description = "ID of the Load Balancer Backend Pool to attach the Virtual Machine to."
  type = object({
    id = string
  })
  default = null
}

variable "application_gateway_attachment" {
  description = "ID of the Application Gateway Backend Pool to attach the Virtual Machine to."
  type = object({
    id = string
  })
  default = null
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
  nullable    = false

  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "StandardSSD_ZRS", "Premium_ZRS"], var.os_disk_storage_account_type)
    error_message = "`var.os_disk_storage_account_type` must be one of `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` or `Premium_ZRS`."
  }
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk."
  type        = string
  default     = "ReadWrite"
}

variable "encryption_at_host_enabled" {
  description = "Should all disks (including the temporary disk) attached to the Virtual Machine be encrypted by enabling Encryption at Host? [List of compatible Virtual Machine sizes](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/disks-enable-host-based-encryption-cli#finding-supported-vm-sizes)."
  type        = bool
  default     = true
}

variable "vtpm_enabled" {
  description = "Specifies if vTPM (virtual Trusted Platform Module) and Trusted Launch is enabled for the Virtual Machine. Defaults to `true`. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "secure_boot_enabled" {
  description = "Specifies if Secure Boot is enabled for the Virtual Machine. Defaults to `true`. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}

variable "ultra_ssd_enabled" {
  description = "Specifies whether Ultra Disks is enabled (`UltraSSD_LRS` storage type for data disks)."
  type        = bool
  default     = null
}

variable "disk_controller_type" {
  description = "Specifies the Disk Controller Type used for this Virtual Machine. Possible values are `SCSI` and `NVMe`."
  type        = string
  default     = null
}

variable "disk_encryption_set_id" {
  description = "ID of the disk encryption set to use to encrypt VM disks."
  type        = string
  default     = null
}

## Identity variables
variable "identity" {
  description = "Map with identity block informations as described [here](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity)."
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
variable "spot_instance_enabled" {
  description = "`true` to deploy Virtual Machine as a Spot Instance."
  type        = bool
  default     = false
  nullable    = false
}

variable "spot_instance_max_bid_price" {
  description = "The maximum price you're willing to pay for this Virtual Machine in US Dollars; must be greater than the current spot price. `-1` If you don't want the Virtual Machine to be evicted for price reasons."
  type        = number
  default     = -1
  nullable    = false
}

variable "spot_instance_eviction_policy" {
  description = "Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. At this time the only supported value is `Deallocate`. Changing this forces a new resource to be created."
  type        = string
  default     = "Deallocate"
  nullable    = false
}

## Backup variable
variable "backup_policy" {
  description = "Backup policy ID from the Recovery Vault to attach the Virtual Machine to (value to `null` to disable backup)."
  type = object({
    id = string
  })
}

## Patching variables
variable "patch_mode" {
  description = "Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are `AutomaticByPlatform` and `ImageDefault`. [Compatibility list is available here](https://learn.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#supported-os-images)."
  type        = string
  default     = "AutomaticByPlatform"
  nullable    = false

  validation {
    condition     = contains(["AutomaticByPlatform", "ImageDefault"], var.patch_mode)
    error_message = "`var.patch_mode` must be either `AutomaticByPlatform` or `ImageDefault`."
  }
}

variable "maintenance_configurations_ids" {
  description = "List of maintenance configurations to attach to this VM."
  type        = list(string)
  default     = []
}

variable "patching_reboot_setting" {
  description = "Specifies the reboot setting for platform scheduled patching. Possible values are `Always`, `IfRequired` and `Never`."
  type        = string
  default     = "IfRequired"
  nullable    = false

  validation {
    condition     = contains(["Always", "IfRequired", "Never"], var.patching_reboot_setting)
    error_message = "`var.patching_reboot_setting` must be either `Always`, `IfRequired` or `Never`."
  }
}

variable "disable_password_authentication" {
  description = "Option to disable or enable password authentication if admin password is not set."
  type        = bool
  default     = true
}
