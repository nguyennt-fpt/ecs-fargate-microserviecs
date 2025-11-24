variable "enable_rds" {
  description = "Enable RDS database"
  type        = bool
  default     = false
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "db_identifier" {
  description = "Database identifier"
  type        = string
  default     = "mydb"
}

variable "db_engine" {
  description = "Database engine (postgres, mysql, mariadb, oracle-ee, sqlserver-ex)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.4"
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
  default     = "postgres"
  sensitive   = true
}

variable "db_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "db_subnet_ids" {
  description = "Database subnet IDs"
  type        = list(string)
  default     = []
}

variable "create_db_subnet_group" {
  description = "Create DB subnet group (automatically enabled when RDS is enabled)"
  type        = bool
  default     = true
}

variable "existing_db_subnet_group_name" {
  description = "Existing DB subnet group name"
  type        = string
  default     = ""
}

variable "rds_security_group_id" {
  description = "RDS security group ID"
  type        = string
}

variable "db_publicly_accessible" {
  description = "Make database publicly accessible"
  type        = bool
  default     = false
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment for high availability"
  type        = bool
  default     = true
}

variable "db_storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "db_storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
}

variable "db_iops" {
  description = "IOPS for gp3/io1 storage"
  type        = number
  default     = 3000
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "db_backup_window" {
  description = "Daily backup window (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "db_maintenance_window" {
  description = "Weekly maintenance window"
  type        = string
  default     = "mon:04:00-mon:05:00"
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = false
}

variable "db_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "db_enable_iam_authentication" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = false
}

variable "create_parameter_group" {
  description = "Create custom parameter group"
  type        = bool
  default     = false
}

variable "db_parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "postgres15"
}

variable "enable_secrets_manager" {
  description = "Store RDS credentials in Secrets Manager"
  type        = bool
  default     = false
}

variable "secrets_recovery_window" {
  description = "Recovery window for Secrets Manager in days"
  type        = number
  default     = 7
}
