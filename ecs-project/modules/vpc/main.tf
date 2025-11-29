# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Data source for availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnets (2 subnets for ALB)
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Private Subnets for ECS (2 subnets for containers)
resource "aws_subnet" "private_ecs" {
  count             = length(var.private_subnet_ecs_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_ecs_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = {
    Name = "${var.project_name}-private-ecs-subnet-${count.index + 1}"
  }
}

# Private Subnets for RDS (minimum 2 subnets for multi-AZ)
resource "aws_subnet" "private_rds" {
  count             = length(var.private_subnet_rds_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_rds_cidrs[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = {
    Name = "${var.project_name}-private-rds-subnet-${count.index + 1}"
  }
}



# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block      = "0.0.0.0/0"
    gateway_id      = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table for ECS subnets (no internet access)
resource "aws_route_table" "private_ecs" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-ecs-rt"
  }
}

# Private Route Table for RDS subnets (no internet access)
resource "aws_route_table" "private_rds" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-private-rds-rt"
  }
}

# Associate ECS private subnets with ECS private route table
resource "aws_route_table_association" "private_ecs" {
  count          = length(aws_subnet.private_ecs)
  subnet_id      = aws_subnet.private_ecs[count.index].id
  route_table_id = aws_route_table.private_ecs.id
}

# Associate RDS private subnets with RDS private route table
resource "aws_route_table_association" "private_rds" {
  count          = length(aws_subnet.private_rds)
  subnet_id      = aws_subnet.private_rds[count.index].id
  route_table_id = aws_route_table.private_rds.id
}

# VPC Endpoint for ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_ecs[*].id
  security_group_ids  = [var.vpc_endpoint_security_group_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ecr-api-endpoint"
  }
}

# VPC Endpoint for ECR Docker Registry
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_ecs[*].id
  security_group_ids  = [var.vpc_endpoint_security_group_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-ecr-dkr-endpoint"
  }
}

# VPC Endpoint for S3 (Gateway endpoint for ECR image layers)
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.private_ecs.id]

  tags = {
    Name = "${var.project_name}-s3-endpoint"
  }
}

# VPC Endpoint for CloudWatch Logs
resource "aws_vpc_endpoint" "logs" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_ecs[*].id
  security_group_ids  = [var.vpc_endpoint_security_group_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-logs-endpoint"
  }
}

# VPC Endpoint for Secrets Manager
resource "aws_vpc_endpoint" "secretsmanager" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.secretsmanager"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = aws_subnet.private_ecs[*].id
  security_group_ids  = [var.vpc_endpoint_security_group_id]
  private_dns_enabled = true

  tags = {
    Name = "${var.project_name}-secretsmanager-endpoint"
  }
}

