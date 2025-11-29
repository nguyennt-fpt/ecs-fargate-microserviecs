output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR block"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnet IDs for ALB"
  value       = aws_subnet.public[*].id
}

output "private_ecs_subnet_ids" {
  description = "Private subnet IDs for ECS containers"
  value       = aws_subnet.private_ecs[*].id
}

output "private_rds_subnet_ids" {
  description = "Private subnet IDs for RDS database"
  value       = aws_subnet.private_rds[*].id
}



output "internet_gateway_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.main.id
}
