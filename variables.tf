variable "auth_token" {
  type        = string
  default     = "{Metal_API_Token}"
  description = "Metal API Key"
}

variable "project_id" {
  type        = string
  default     = "{Metal_Project_ID}"
  description = "The project id to deploy into"
}

variable "metro" {
  type        = string
  default     = "da"
  description = "Metal Metro to deploy into"
}

variable "plan" {
  type        = string
  default     = "c3.small.x86"
  description = "Metal server type to deploy"
}

variable "server_count" {
  type        = number
  default     = 4
  description = "How many servers will you deploy"
}

variable "hostname" {
  type        = string
  default     = "windows"
  description = "Hostname for the server, NO Index, it will be applied during deployment"
}

variable "administrator_password" {
  type        = string
  default     = "Change@me-123!!"
  description = "New Administrator Password"
}

