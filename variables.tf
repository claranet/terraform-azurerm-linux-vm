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

variable "name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
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
variable "custom_public_ip_name" {
  description = "Custom name for public IP. Should be suffixed by \"-pubip\". Generated if not set."
  type        = string
  default     = null
}

variable "custom_nic_name" {
  description = "Custom name for the NIC interface. Should be suffixed by \"-nic\". Generated if not set."
  type        = string
  default     = null
}

variable "nic_enable_accelerated_networking" {
  description = "Should Accelerated Networking be enabled? Defaults to `false`."
  type        = bool
  default     = false
}

variable "nic_extra_tags" {
  description = "Extra tags to set on the network interface."
  type        = map(string)
  default     = {}
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

variable "custom_ipconfig_name" {
  description = "Custom name for the IP config of the NIC. Should be suffixed by \"-nic-ipconfig\". Generated if not set."
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

variable "custom_name" {
  description = "Custom name for the Virtual Machine. Should be suffixed by \"-vm\". Generated if not set."
  type        = string
  default     = ""
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

variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store vm diagnostics"
  type        = string
}

variable "diagnostics_storage_account_sas_token" {
  description = "SAS token of the Storage Account in which store vm diagnostics"
  type        = string
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
  type        = map(any)
  default     = {}
}

variable "storage_data_disk_extra_tags" {
  description = "[DEPRECATED] Extra tags to set on each data storage disk."
  type        = map(string)
  default     = {}
}

variable "vm_image_id" {
  description = "The ID of the Image which this Virtual Machine should be created from. This variable cannot be used if `vm_image` is already defined."
  type        = string
  default     = null
}

variable "extra_tags" {
  description = "Extra tags to set on each created resource."
  type        = map(string)
  default     = {}
}

variable "certificate_validity_in_months" {
  description = "The created certificate validity in months"
  type        = string
  default     = "48"
}

variable "custom_dns_label" {
  description = "The DNS label to use for public access. VM name if not set. DNS will be <label>.westeurope.cloudapp.azure.com"
  type        = string
  default     = ""
}

variable "public_ip_extra_tags" {
  description = "Extra tags to set on the public IP resource."
  type        = map(string)
  default     = {}
}

variable "public_ip_sku" {
  description = "Sku for the public IP attached to the VM. Can be `null` if no public IP needed."
  type        = string
  default     = "Standard"
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

variable "os_disk_type" {
  description = "Specifies the type of managed disk to create (Standard_LRS, StandardSSD_LRS, Premium_LRS)"
  type        = string
  default     = "Standard_LRS"
}

variable "os_disk_size_gb" {
  description = "Specifies the size of the OS disk in gigabytes"
  type        = string
  default     = null
}

variable "os_disk_custom_name" {
  description = "Custom name for OS disk. Should be suffixed by \"-osdisk\". Generated if not set."
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
