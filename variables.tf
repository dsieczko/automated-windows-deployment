variable "project_id" {
  type        = string
  description = "The project id to deploy into"
}

variable "metro" {
  type        = string
  description = "Metal metro to deploy into"
}

variable "plan" {
  type        = string
  description = "Metal server type to deploy"
}

variable "hostname" {
  type        = string
  default     = "windows"
  description = "Hostname for the server, it will be applied during deployment"
}

variable "admin_password" {
  type        = string
  description = "New administrator password"
}

variable "billing_cycle" {
  type        = string
  default     = "hourly"
  description = "Billing cycle for device"
}

variable "operating_system" {
  type        = string
  default     = "windows_2019"
  description = "Billing cycle for device"
}

variable "script1_path" {
  type        = string
  description = "Path to 1st PowerShell script"
}

variable "script2_path" {
  type        = string
  description = "Path to 2nd PowerShell script"
}