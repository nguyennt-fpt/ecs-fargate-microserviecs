output "db_instance_endpoint" {
  description = "Database instance endpoint"
  value       = try(aws_db_instance.main[0].endpoint, null)
}

output "db_instance_address" {
  description = "Database instance address"
  value       = try(aws_db_instance.main[0].address, null)
}

output "db_instance_port" {
  description = "Database instance port"
  value       = try(aws_db_instance.main[0].port, null)
}

output "db_instance_arn" {
  description = "Database instance ARN"
  value       = try(aws_db_instance.main[0].arn, null)
}

output "db_instance_id" {
  description = "Database instance identifier"
  value       = try(aws_db_instance.main[0].id, null)
}

output "rds_secret_arn" {
  description = "RDS secret ARN"
  value       = try(aws_db_instance.main[0].master_user_secret[0].secret_arn, null)
}
