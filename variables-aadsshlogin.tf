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
