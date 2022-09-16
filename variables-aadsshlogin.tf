variable "aad_ssh_login_enabled" {
  description = "Enable SSH logins with Azure Active Directory"
  type        = bool
  default     = false
}

variable "aad_ssh_login_extension_version" {
  description = "VM Extension version for Azure Active Directory SSH Login extension"
  type        = string
  default     = "1.0"
}

variable "aad_ssh_login_user_objects_ids" {
  description = "Azure Active Directory objects IDs allowed to connect as standard user on the VM."
  type        = list(string)
  default     = []
}

variable "aad_ssh_login_admin_objects_ids" {
  description = "Azure Active Directory objects IDs allowed to connect as administrator on the VM."

  type    = list(string)
  default = []
}
