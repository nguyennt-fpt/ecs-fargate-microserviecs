terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  aws_region                      = var.aws_region
  project_name                    = var.project_name
  vpc_cidr                        = var.vpc_cidr
  public_subnet_cidrs             = var.public_subnet_cidrs
  private_subnet_ecs_cidrs        = var.private_subnet_ecs_cidrs
  private_subnet_rds_cidrs        = var.private_subnet_rds_cidrs
  vpc_endpoint_security_group_id  = module.security.vpc_endpoint_security_group_id
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  project_name       = var.project_name
  enable_rds_access  = var.enable_rds && var.enable_secrets_manager
  rds_secret_arns    = var.enable_rds && var.enable_secrets_manager ? [try(module.rds.rds_secret_arn, "")] : []
}

# Security Groups Module
module "security" {
  source = "./modules/security"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  vpc_cidr     = var.vpc_cidr
  enable_rds   = var.enable_rds
  rds_port     = var.db_port
  app_port     = var.app_port
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  project_name           = var.project_name
  vpc_id                 = module.vpc.vpc_id
  public_subnet_ids      = module.vpc.public_subnet_ids
  alb_security_group_id  = module.security.alb_security_group_id
  app_port               = var.app_port
  listener_port          = var.listener_port
  listener_protocol      = var.listener_protocol
  health_check_path      = var.health_check_path

}

# ECS Module
module "ecs" {
  source = "./modules/ecs"

  aws_region                    = var.aws_region
  project_name                  = var.project_name
  private_subnet_ids            = module.vpc.private_ecs_subnet_ids
  ecs_tasks_security_group_id   = module.security.ecs_tasks_security_group_id
  target_group_arn              = module.alb.target_group_arn
  load_balancer_ready           = module.alb.alb_arn
  
  container_name                = var.container_name
  container_image               = var.container_image
  app_port                      = var.app_port
  task_cpu                      = var.task_cpu
  task_memory                   = var.task_memory
  desired_count                 = var.desired_count
  min_capacity                  = var.min_capacity
  max_capacity                  = var.max_capacity
  target_cpu_utilization        = var.target_cpu_utilization
  target_memory_utilization     = var.target_memory_utilization
  
  execution_role_arn            = module.iam.ecs_task_execution_role_arn
  task_role_arn                 = module.iam.ecs_task_role_arn
  log_retention_days            = var.log_retention_days
  enable_container_insights     = var.enable_container_insights
  environment_variables         = concat(
    var.environment_variables,
    var.enable_rds ? [
      {
        name  = "MYSQL_HOST"
        value = try(module.rds.db_instance_address, "")
      },
      {
        name  = "MYSQL_DB"
        value = var.db_name
      },
      {
        name  = "MYSQL_PORT"
        value = tostring(var.db_port)
      }
    ] : []
  )
  secrets                       = concat(
    var.secrets,
    var.enable_rds && var.enable_secrets_manager ? [
      {
        name      = "MYSQL_USER"
        valueFrom = "${try(module.rds.rds_secret_arn, "")}:username::"
      },
      {
        name      = "MYSQL_PASSWORD"
        valueFrom = "${try(module.rds.rds_secret_arn, "")}:password::"
      }
    ] : []
  )
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  enable_rds                      = var.enable_rds
  project_name                    = var.project_name
  db_identifier                   = var.db_identifier
  db_engine                       = var.db_engine
  db_engine_version               = var.db_engine_version
  db_instance_class               = var.db_instance_class
  db_allocated_storage            = var.db_allocated_storage
  db_max_allocated_storage        = var.db_max_allocated_storage
  db_name                         = var.db_name
  db_username                     = var.db_username
  db_password                     = var.db_password
  db_port                         = var.db_port
  db_subnet_ids                   = module.vpc.private_rds_subnet_ids
  rds_security_group_id           = module.security.rds_security_group_id
  db_multi_az                     = var.db_multi_az
  db_storage_encrypted            = var.db_storage_encrypted
  db_backup_retention_period      = var.db_backup_retention_period
  enable_secrets_manager          = var.enable_secrets_manager
  db_storage_type                 = var.db_storage_type
}

# Secret Manager is automatically created by AWS RDS when manage_master_user_password = true

# WAF Module
module "waf" {
  source = "./modules/waf"

  project_name = var.project_name
  alb_arn      = module.alb.alb_arn
  rate_limit   = var.waf_rate_limit

  count = var.enable_waf ? 1 : 0
}



# Security Monitoring Module
module "security_monitoring" {
  source = "./modules/security-monitoring"

  project_name               = var.project_name
  vpc_id                     = module.vpc.vpc_id
  enable_guardduty           = var.enable_guardduty
  enable_vpc_flow_logs       = var.enable_vpc_flow_logs
  flow_log_retention_days    = var.flow_log_retention_days
  security_alert_email       = var.security_alert_email
  enable_s3_monitoring       = var.enable_s3_monitoring
}
