variable "enable_elasticache" {
  description = "Enable ElastiCache cluster"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "engine" {
  description = "Cache engine (redis or memcached)"
  type        = string
  default     = "redis"
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "Node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "port" {
  description = "Cache port"
  type        = number
  default     = 6379
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "redis7"
}

variable "elasticache_subnet_ids" {
  description = "ElastiCache subnet IDs"
  type        = list(string)
  default     = []
}

variable "create_subnet_group" {
  description = "Create subnet group"
  type        = bool
  default     = true
}

variable "existing_subnet_group_name" {
  description = "Existing subnet group name"
  type        = string
  default     = ""
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = false
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Enable transit encryption"
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "AUTH token for Redis"
  type        = string
  default     = ""
  sensitive   = true
}

variable "maintenance_window" {
  description = "Maintenance window"
  type        = string
  default     = "mon:03:00-mon:04:00"
}

variable "notification_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
  default     = ""
}

variable "snapshot_retention_limit" {
  description = "Snapshot retention limit in days (Redis only)"
  type        = number
  default     = 5
}

variable "snapshot_window" {
  description = "Snapshot window (Redis only)"
  type        = string
  default     = "03:00-05:00"
}

variable "parameters" {
  description = "Parameter group parameters"
  type        = map(string)
  default     = {}
}
