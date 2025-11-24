# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  count           = var.enable_elasticache && var.create_subnet_group ? 1 : 0
  name            = "${var.project_name}-elasticache-subnet-group"
  subnet_ids      = var.elasticache_subnet_ids
  
  tags = {
    Name = "${var.project_name}-elasticache-subnet-group"
  }
}

# ElastiCache Cluster (Redis)
resource "aws_elasticache_cluster" "redis" {
  count                 = var.enable_elasticache && var.engine == "redis" ? 1 : 0
  cluster_id            = "${var.project_name}-redis"
  engine                = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = length(aws_elasticache_parameter_group.main) > 0 ? aws_elasticache_parameter_group.main[0].name : "default.redis7"
  engine_version       = var.engine_version
  port                 = var.port
  
  subnet_group_name       = length(aws_elasticache_subnet_group.main) > 0 ? aws_elasticache_subnet_group.main[0].name : null
  security_group_ids      = [var.security_group_id]
  
  maintenance_window = var.maintenance_window
  
  tags = {
    Name = "${var.project_name}-redis"
  }
}

# ElastiCache Cluster (Memcached)
resource "aws_elasticache_cluster" "memcached" {
  count                 = var.enable_elasticache && var.engine == "memcached" ? 1 : 0
  cluster_id            = "${var.project_name}-memcached"
  engine                = var.engine
  node_type            = var.node_type
  num_cache_nodes      = var.num_cache_nodes
  parameter_group_name = length(aws_elasticache_parameter_group.main) > 0 ? aws_elasticache_parameter_group.main[0].name : "default.memcached1.6"
  engine_version       = var.engine_version
  port                 = var.port
  
  subnet_group_name  = length(aws_elasticache_subnet_group.main) > 0 ? aws_elasticache_subnet_group.main[0].name : null
  security_group_ids = [var.security_group_id]
  
  maintenance_window = var.maintenance_window
  
  tags = {
    Name = "${var.project_name}-memcached"
  }
}

# ElastiCache Parameter Group
resource "aws_elasticache_parameter_group" "main" {
  count  = var.enable_elasticache ? 1 : 0
  name   = "${var.project_name}-${var.engine}-params"
  family = var.parameter_group_family
  
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
  
  tags = {
    Name = "${var.project_name}-${var.engine}-params"
  }
}