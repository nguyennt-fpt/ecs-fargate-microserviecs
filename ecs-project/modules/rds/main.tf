# DB Subnet Group (requires minimum 2 subnets in different AZs)
resource "aws_db_subnet_group" "main" {
  count           = var.enable_rds && length(var.db_subnet_ids) >= 2 ? 1 : 0
  name            = "${var.project_name}-db-subnet-group"
  subnet_ids      = var.db_subnet_ids
  
  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  count                  = var.enable_rds && length(var.db_subnet_ids) >= 2 ? 1 : 0
  identifier             = var.db_identifier
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  
  db_name  = var.db_name
  username = var.db_username
  manage_master_user_password = var.enable_secrets_manager
  password = var.enable_secrets_manager ? null : var.db_password
  
  db_subnet_group_name   = length(aws_db_subnet_group.main) > 0 ? aws_db_subnet_group.main[0].name : null
  vpc_security_group_ids = [var.rds_security_group_id]
  
  publicly_accessible    = var.db_publicly_accessible
  multi_az               = var.db_multi_az
  storage_encrypted      = var.db_storage_encrypted
  storage_type           = var.db_storage_type
  
  backup_retention_period = var.db_backup_retention_period
  backup_window          = var.db_backup_window
  maintenance_window     = var.db_maintenance_window
  
  skip_final_snapshot       = var.db_skip_final_snapshot
  final_snapshot_identifier = var.db_skip_final_snapshot ? null : "${var.db_identifier}-final-snapshot"
  
  deletion_protection = var.db_deletion_protection
  iam_database_authentication_enabled = var.db_enable_iam_authentication
  
  parameter_group_name = length(aws_db_parameter_group.main) > 0 ? aws_db_parameter_group.main[0].name : null

  tags = {
    Name = "${var.project_name}-rds"
  }
}

# RDS Parameter Group (PostgreSQL example)
resource "aws_db_parameter_group" "main" {
  count           = var.enable_rds && var.create_parameter_group ? 1 : 0
  family          = var.db_parameter_group_family
  name            = "${var.project_name}-db-params"
  
  tags = {
    Name = "${var.project_name}-db-params"
  }
}

# AWS will automatically create Secret Manager when manage_master_user_password = true
