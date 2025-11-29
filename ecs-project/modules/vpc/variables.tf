variable "project_name" {
  description = "Project name for naming VPC and resources"
  type        = string
}

variable "aws_region" {
  description = "AWS region for VPC endpoints"
  type        = string
}

variable "vpc_endpoint_security_group_id" {
  description = "VPC endpoint security group ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block (e.g., 10.0.0.0/16)"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (2 subnets for ALB/IGW)"
  type        = list(string)
  # Example: ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_ecs_cidrs" {
  description = "List of CIDR blocks for private subnets for ECS containers (2 subnets)"
  type        = list(string)
  # Example: ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnet_rds_cidrs" {
  description = "List of CIDR blocks for private subnets for RDS database (minimum 2 subnets for multi-AZ)"
  type        = list(string)
  # Example: ["10.0.20.0/24", "10.0.21.0/24"]
  validation {
    condition     = length(var.private_subnet_rds_cidrs) >= 2
    error_message = "RDS requires minimum 2 subnets in different AZs for DB subnet group."
  }
}
