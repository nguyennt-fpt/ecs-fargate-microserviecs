variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "enable_guardduty" {
  description = "Enable GuardDuty"
  type        = bool
  default     = true
}

variable "enable_vpc_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "flow_log_retention_days" {
  description = "VPC Flow Logs retention in days"
  type        = number
  default     = 14
}

variable "security_alert_email" {
  description = "Email address for security alerts"
  type        = string
  default     = ""
}

variable "enable_s3_monitoring" {
  description = "Enable S3 logs monitoring in GuardDuty"
  type        = bool
  default     = false
}