variable "diagnostics_storage_account_name" {
  description = "Name of the Storage Account in which store boot diagnostics."
  type        = string
}

## Logs & monitoring variables
variable "monitoring_agent_enabled" {
  description = "True to use and deploy the Azure Monitor Agent."
  type        = bool
  default     = true
  nullable    = false
}

variable "log_analytics_workspace_guid" {
  description = "GUID of the Log Analytics Workspace to link with."
  type        = string
  default     = null
}

variable "log_analytics_workspace_key" {
  description = "Access key of the Log Analytics Workspace to link with."
  type        = string
  default     = null
}

variable "azure_monitor_data_collection_rule" {
  description = "Data Collection Rule ID from Azure Monitor for metrics and logs collection. Used with new monitoring agent, set to `null` to disable."
  type = object({
    id = string
  })
}

variable "azure_monitor_agent_version" {
  description = "Azure Monitor Agent extension version"
  type        = string
  default     = "1.21"
}

variable "azure_monitor_agent_auto_upgrade_enabled" {
  description = "Automatically update agent when publisher releases a new version of the agent."
  type        = bool
  default     = false
}

variable "log_analytics_agent_enabled" {
  description = "Deploy Log Analytics VM extension - depending of OS [compatibility list](https://docs.microsoft.com/fr-fr/azure/azure-monitor/agents/agents-overview#linux)."
  type        = bool
  default     = false
}

variable "log_analytics_agent_version" {
  description = "Azure Log Analytics extension version."
  type        = string
  default     = "1.14"
}
