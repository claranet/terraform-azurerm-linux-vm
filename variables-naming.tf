# Generic naming variables
variable "name_prefix" {
  description = "Optional prefix for the generated name."
  type        = string
  default     = ""
}

variable "name_suffix" {
  description = "Optional suffix for the generated name."
  type        = string
  default     = ""
}

# Custom naming override
variable "custom_name" {
  description = "Custom name for the Virtual Machine. Generated if not set."
  type        = string
  default     = ""
}

variable "computer_name" {
  description = "Custom name for the Virtual Machine Hostname. `vm_name` if not set."
  type        = string
  default     = ""
}

variable "public_ip_custom_name" {
  description = "Custom name for Public IP. Generated if not set."
  type        = string
  default     = null
}

variable "nic_custom_name" {
  description = "Custom name for the NIC interface. Generated if not set."
  type        = string
  default     = null
}

variable "ip_configuration_custom_name" {
  description = "Custom name for the IP config of the NIC. Generated if not set."
  type        = string
  default     = null
}

variable "os_disk_custom_name" {
  description = "Custom name for OS disk. Generated if not set."
  type        = string
  default     = null
}

variable "dcr_custom_name" {
  description = "Custom name for Data collection rule association."
  type        = string
  default     = null
}
