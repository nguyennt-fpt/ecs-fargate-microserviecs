variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "ecs-app"
}

# VPC Configuration
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks (for ALB)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_ecs_cidrs" {
  description = "Private subnet CIDR blocks for ECS containers"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnet_rds_cidrs" {
  description = "Private subnet CIDR blocks for RDS database"
  type        = list(string)
  default     = ["10.0.20.0/24", "10.0.21.0/24"]
}

# ALB Configuration
variable "listener_port" {
  description = "Listener port"
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Listener protocol"
  type        = string
  default     = "HTTP"
}



# Container Configuration
variable "container_name" {
  description = "Container name"
  type        = string
  default     = "app"
}

variable "container_image" {
  description = "Docker image URI"
  type        = string
  default     = "nginx:latest"
}

variable "app_port" {
  description = "Application port"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/"
}

# Task Configuration
variable "task_cpu" {
  description = "Task CPU units (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Task memory in MB"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of tasks for auto scaling"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of tasks for auto scaling"
  type        = number
  default     = 4
}

variable "target_cpu_utilization" {
  description = "Target CPU utilization percentage"
  type        = number
  default     = 70
}

variable "target_memory_utilization" {
  description = "Target memory utilization percentage"
  type        = number
  default     = 80
}

# ECS Configuration
variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 30
}

variable "enable_container_insights" {
  description = "Enable Container Insights"
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "Environment variables for container"
  type        = list(map(string))
  default     = []
}

variable "secrets" {
  description = "Secrets for container from Secrets Manager"
  type        = list(map(string))
  default     = []
}

# RDS Configuration
variable "enable_rds" {
  description = "Enable RDS database"
  type        = bool
  default     = false
}

variable "db_identifier" {
  description = "Database identifier"
  type        = string
  default     = "mydb"
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0.43"
}

variable "db_instance_class" {
  description = "Database instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_allocated_storage" {
  description = "Initial allocated storage in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum allocated storage for autoscaling in GB"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "myapp"
}

variable "db_username" {
  description = "Master username"
  type        = string
  default     = "admin"
  sensitive   = true
}

variable "db_password" {
  description = "Master password (optional when using AWS managed password)"
  type        = string
  default     = null
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "db_storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "enable_secrets_manager" {
  description = "Store RDS credentials in Secrets Manager"
  type        = bool
  default     = false
}

variable "app_secrets" {
  description = "Application secrets as key-value pairs"
  type        = map(string)
  default     = {}
  sensitive   = true
}

# WAF Configuration
variable "enable_waf" {
  description = "Enable AWS WAF"
  type        = bool
  default     = false
}

variable "waf_rate_limit" {
  description = "WAF rate limit per 5 minutes"
  type        = number
  default     = 2000
}

# ElastiCache Configuration
variable "enable_elasticache" {
  description = "Enable ElastiCache cluster"
  type        = bool
  default     = false
}

variable "elasticache_engine" {
  description = "Cache engine (redis or memcached)"
  type        = string
  default     = "redis"
}

variable "elasticache_version" {
  description = "Cache engine version"
  type        = string
  default     = "7.0"
}

variable "elasticache_node_type" {
  description = "Cache node type"
  type        = string
  default     = "cache.t3.micro"
}

variable "elasticache_num_cache_nodes" {
  description = "Number of cache nodes"
  type        = number
  default     = 1
}

variable "elasticache_port" {
  description = "Cache port"
  type        = number
  default     = 6379
}

variable "elasticache_parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "redis7"
}

variable "elasticache_multi_az" {
  description = "Enable Multi-AZ for cache"
  type        = bool
  default     = false
}

variable "elasticache_automatic_failover" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "elasticache_at_rest_encryption" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "elasticache_transit_encryption" {
  description = "Enable transit encryption"
  type        = bool
  default     = true
}

variable "elasticache_parameters" {
  description = "ElastiCache parameter group parameters"
  type        = map(string)
  default     = {}
}

variable "db_storage_type" {
  description = "Database storage type"
  type        = string
  default     = "gp3"
}

# Security Monitoring Configuration
variable "enable_guardduty" {
  description = "Enable GuardDuty threat detection"
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
