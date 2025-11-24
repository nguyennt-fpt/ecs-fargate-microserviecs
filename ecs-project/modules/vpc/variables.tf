variable "project_name" {
  description = "Project name để đặt tên cho VPC và các resources"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block (ví dụ: 10.0.0.0/16)"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "Danh sách CIDR blocks cho public subnets (2 subnets cho ALB/IGW)"
  type        = list(string)
  # Ví dụ: ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_ecs_cidrs" {
  description = "Danh sách CIDR blocks cho private subnets dành cho ECS containers (2 subnets)"
  type        = list(string)
  # Ví dụ: ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "private_subnet_rds_cidrs" {
  description = "Danh sách CIDR blocks cho private subnets dành cho RDS database (tối thiểu 2 subnet cho multi-AZ)"
  type        = list(string)
  # Ví dụ: ["10.0.20.0/24", "10.0.21.0/24"]
  validation {
    condition     = length(var.private_subnet_rds_cidrs) >= 2
    error_message = "RDS yêu cầu tối thiểu 2 subnet trong 2 AZ khác nhau cho DB subnet group."
  }
}
