variable "location" {
  description = "Azure location."
  type        = string
}

variable "location_short" {
  description = "Short string for Azure location."
  type        = string
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
}

variable "environment" {
  description = "Project environment"
  type        = string
}

variable "stack" {
  description = "Project stack name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subnet_id" {
  description = "Id of the Subnet in which create the Virtual Machine"
  type        = string
}

### SSH Connection inputs
variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  default     = null
}

### Password authentication
variable "admin_password" {
  description = "Password for the administrator account of the virtual machine."
  type        = string
  default     = null
}

### Network inputs
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
variable "admin_username" {
  description = "Username for Virtual Machine administrator account"
  type        = string
}

variable "custom_data" {
  description = "Custom data. See https://www.terraform.io/docs/providers/azurerm/r/virtual_machine.html#os_profile block"
  type        = any
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
  description = <<EOT
Map of objects to configure storage data disk(s).
    disk1 = {
      name                 = string ,
      create_option        = string ,
      disk_size_gb         = string ,
      lun                  = string ,
      storage_account_type = string ,
      extra_tags           = map(string)
    }
EOT
  type        = any
  default     = {}
}

variable "vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable cannot be used if `vm_image` is already defined."
  type        = string
  default     = null
}

variable "custom_dns_label" {
  description = "The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com"
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
  description = "True to attach this VM to a Load Balancer"
  type        = bool
  default     = false
}

variable "load_balancer_backend_pool_id" {
  description = "Id of the Load Balancer Backend Pool to attach the VM."
  type        = string
  default     = null
}

variable "attach_application_gateway" {
  description = "True to attach this VM to an Application Gateway"
  type        = bool
  default     = false
}

variable "application_gateway_backend_pool_id" {
  description = "Id of the Application Gateway Backend Pool to attach the VM."
  type        = string
  default     = null
}

variable "os_disk_size_gb" {
  description = "Specifies the size of the OS disk in gigabytes"
  type        = string
  default     = null
}

variable "os_disk_storage_account_type" {
  description = "The Type of Storage Account which should back this the Internal OS Disk. (Standard_LRS, StandardSSD_LRS and Premium_LRS)"
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_caching" {
  description = "Specifies the caching requirements for the OS Disk"
  type        = string
  default     = "ReadWrite"
}

## Identity variables
variable "identity" {
  description = "Map with identity block informations as described here https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine#identity"
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
