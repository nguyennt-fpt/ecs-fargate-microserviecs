output "db_secret_arn" {
  description = "ARN of the database secret"
  value       = var.enable_secrets_manager ? aws_secretsmanager_secret.db_password[0].arn : ""
}

output "app_secret_arn" {
  description = "ARN of the application secret"
  value       = var.enable_secrets_manager && length(var.app_secrets) > 0 ? aws_secretsmanager_secret.app_secrets[0].arn : ""
}