variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "ecs_tasks_security_group_id" {
  description = "ECS tasks security group ID"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN"
  type        = string
}

variable "load_balancer_ready" {
  description = "Load balancer ready dependency"
  type        = string
  default     = null
}

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

variable "launch_type" {
  description = "Launch type (FARGATE or EC2)"
  type        = string
  default     = "FARGATE"
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = false
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

variable "execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}

variable "task_role_arn" {
  description = "ECS task role ARN"
  type        = string
}

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

variable "deployment_max_percent" {
  description = "Maximum percent of tasks during deployment"
  type        = number
  default     = 200
}

variable "deployment_min_healthy_percent" {
  description = "Minimum healthy percent during deployment"
  type        = number
  default     = 100
}

variable "enable_execute_command" {
  description = "Enable execute command for ECS Exec"
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
