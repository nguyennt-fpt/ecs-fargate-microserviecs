variable "project_name" {
  description = "Project name"
  type        = string
}

variable "enable_rds_access" {
  description = "Enable RDS access for ECS tasks"
  type        = bool
  default     = false
}

variable "rds_secret_arns" {
  description = "ARNs of RDS secrets"
  type        = list(string)
  default     = []
}

variable "enable_s3_access" {
  description = "Enable S3 access for ECS tasks"
  type        = bool
  default     = false
}
