output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = module.alb.alb_dns_name
}

output "alb_arn" {
  description = "Load balancer ARN"
  value       = module.alb.alb_arn
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = module.ecs.cluster_name
}

output "ecs_cluster_arn" {
  description = "ECS cluster ARN"
  value       = module.ecs.cluster_arn
}

output "ecs_service_name" {
  description = "ECS service name"
  value       = module.ecs.service_name
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = module.ecs.log_group_name
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = module.alb.target_group_arn
}

output "rds_endpoint" {
  description = "RDS database endpoint"
  value       = try(module.rds.db_instance_endpoint, "RDS not enabled")
  sensitive   = true
}

output "rds_address" {
  description = "RDS database address"
  value       = try(module.rds.db_instance_address, "RDS not enabled")
  sensitive   = true
}



output "rds_secret_arn" {
  description = "RDS secret ARN from AWS Secrets Manager"
  value       = try(module.rds.rds_secret_arn, "RDS secrets not enabled")
  sensitive   = true
}

output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = module.security_monitoring.guardduty_detector_id
}

output "vpc_flow_log_id" {
  description = "VPC Flow Log ID"
  value       = module.security_monitoring.vpc_flow_log_id
}

output "security_alerts_topic_arn" {
  description = "SNS topic ARN for security alerts"
  value       = module.security_monitoring.security_alerts_topic_arn
}
