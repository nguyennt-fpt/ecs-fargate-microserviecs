variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}



variable "enable_rds" {
  description = "Enable RDS security group"
  type        = bool
  default     = false
}

variable "rds_port" {
  description = "RDS port"
  type        = number
  default     = 5432
}



variable "app_port" {
  description = "Application port"
  type        = number
  default     = 3000
}
