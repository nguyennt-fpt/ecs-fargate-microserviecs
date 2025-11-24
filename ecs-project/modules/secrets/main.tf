# Database password secret
resource "aws_secretsmanager_secret" "db_password" {
  count       = var.enable_secrets_manager ? 1 : 0
  name        = "${var.project_name}/rds/password"
  description = "Database password for ${var.project_name}"

  tags = {
    Name = "${var.project_name}-db-password"
  }
}

resource "aws_secretsmanager_secret_version" "db_password" {
  count     = var.enable_secrets_manager ? 1 : 0
  secret_id = aws_secretsmanager_secret.db_password[0].id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    engine   = var.db_engine
    host     = var.db_host
    port     = var.db_port
    dbname   = var.db_name
  })
}

# Application secrets
resource "aws_secretsmanager_secret" "app_secrets" {
  count       = var.enable_secrets_manager && length(var.app_secrets) > 0 ? 1 : 0
  name        = "${var.project_name}/app/secrets"
  description = "Application secrets for ${var.project_name}"

  tags = {
    Name = "${var.project_name}-app-secrets"
  }
}

resource "aws_secretsmanager_secret_version" "app_secrets" {
  count         = var.enable_secrets_manager && length(var.app_secrets) > 0 ? 1 : 0
  secret_id     = aws_secretsmanager_secret.app_secrets[0].id
  secret_string = jsonencode(var.app_secrets)
}