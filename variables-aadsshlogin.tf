variable "entra_ssh_login_enabled" {
  description = "Enable SSH logins with Entra ID (aka AAD)."
  type        = bool
  default     = false
}

variable "entra_ssh_login_extension_version" {
  description = "VM Extension version for Entra ID (aka AAD) SSH Login extension."
  type        = string
  default     = "1.0"
}

variable "entra_ssh_login_user_objects_ids" {
  description = "Entra ID (aka AAD) objects IDs allowed to connect as standard user on the VM."
  type        = list(string)
  default     = []
}

variable "entra_ssh_login_admin_objects_ids" {
  description = "Entra ID (aka AAD) objects IDs allowed to connect as administrator on the VM."

  type    = list(string)
  default = []
}
