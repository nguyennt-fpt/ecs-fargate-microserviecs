variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "enable_secrets_manager" {
  description = "Enable AWS Secrets Manager"
  type        = bool
  default     = false
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = ""
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = ""
  sensitive   = true
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = ""
}

variable "db_host" {
  description = "Database host"
  type        = string
  default     = ""
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = ""
}

variable "app_secrets" {
  description = "Application secrets as key-value pairs"
  type        = map(string)
  default     = {}
  sensitive   = true
}