output "elasticache_cluster_id" {
  description = "ElastiCache cluster ID"
  value       = try(
    var.engine == "redis" ? aws_elasticache_cluster.redis[0].id : aws_elasticache_cluster.memcached[0].id,
    null
  )
}

output "elasticache_endpoint" {
  description = "ElastiCache primary endpoint"
  value       = try(
    var.engine == "redis" ? aws_elasticache_cluster.redis[0].cache_nodes[0].address : aws_elasticache_cluster.memcached[0].cache_nodes[0].address,
    null
  )
}

output "elasticache_port" {
  description = "ElastiCache port"
  value       = try(
    var.engine == "redis" ? aws_elasticache_cluster.redis[0].port : aws_elasticache_cluster.memcached[0].port,
    null
  )
}

output "elasticache_engine" {
  description = "ElastiCache engine"
  value       = var.engine
}
