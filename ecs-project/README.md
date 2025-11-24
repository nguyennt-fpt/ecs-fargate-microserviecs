# ECS Terraform Project

This Terraform project deploys a complete ECS (Elastic Container Service) application on AWS using a modular architecture. It provides flexibility to enable/disable components as needed.

## Architecture

### Core Components
- **VPC**: Custom VPC with public and private subnets across 2 availability zones
- **ALB**: Application Load Balancer for traffic distribution
- **ECS**: Fargate-based ECS cluster for container orchestration
- **Auto Scaling**: Automatic scaling based on CPU and memory utilization
- **Security**: Security groups, IAM roles, and proper networking

### Optional Components
- **RDS**: Relational database (PostgreSQL, MySQL, MariaDB, etc.)
- **ElastiCache**: Distributed cache (Redis or Memcached)

## Project Structure

```
ecs-project/
├── main.tf                 # Root configuration using modules
├── variables.tf            # Variable definitions
├── outputs.tf              # Output values
├── terraform.tfvars.example # Template for variable values
├── terraform.tfvars        # Variable values (git ignored)
├── iam.tf                  # Legacy IAM file (see module)
├── .gitignore              # Git ignore rules
├── README.md               # This file
└── modules/
    ├── vpc/                # VPC and networking
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── iam/                # IAM roles and policies
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security/           # Security groups
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── alb/                # Application Load Balancer
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── ecs/                # ECS cluster and service
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── rds/                # RDS database (optional)
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── elasticache/        # ElastiCache cluster (optional)
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Prerequisites

- AWS Account with appropriate permissions
- Terraform >= 1.0
- AWS CLI configured with credentials

## Security Setup

### Before deploying:

1. Copy `terraform.tfvars.example` to `terraform.tfvars`:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Update sensitive values in `terraform.tfvars`:
   - Replace `YOUR_ECR_REPO_URL` with your actual ECR repository
   - Set strong passwords for database

3. Use environment variables for sensitive data:
   ```bash
   export TF_VAR_db_password="your_secure_password"
   export TF_VAR_mysql_password="your_mysql_password"
   ```

4. Consider using AWS Secrets Manager for production:
   ```hcl
   enable_secrets_manager = true
   ```

### Files ignored by Git:
- `terraform.tfvars` (contains sensitive data)
- `terraform.tfstate*` (contains infrastructure state)
- `.terraform/` (Terraform cache)

**⚠️ Never commit sensitive data to version control!**

## Quick Start

### 1. Setup Configuration

```bash
# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars with your values
# Replace YOUR_ECR_REPO_URL with actual ECR repository
# Set secure passwords

# Initialize Terraform
terraform init
```

### 2. Review the Plan

```bash
terraform plan
```

### 3. Apply the Configuration

```bash
terraform apply
```

### 4. Get Outputs

```bash
terraform output alb_dns_name
```

## Configuration

All settings are in `terraform.tfvars`. Key configurations:

### Basic Configuration

```hcl
aws_region   = "ap-southeast-1"
project_name = "ecs-fargate-microservices"
```

### VPC Configuration

```hcl
vpc_cidr                  = "10.10.0.0/16"
public_subnet_cidrs       = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_ecs_cidrs  = ["10.10.3.0/24", "10.10.4.0/24"]
private_subnet_rds_cidrs  = ["10.10.5.0/24", "10.10.6.0/24"]
```

### Container Configuration

```hcl
container_name  = "web-app"
container_image = "YOUR_ECR_REPO_URL:latest"  # Replace with your ECR URL
app_port        = 3000  # Node.js default port
task_cpu        = "256"
task_memory     = "512"
desired_count   = 2
```

### Enable RDS

```hcl
enable_rds                = true
db_engine                 = "mysql"
db_engine_version         = "8.0.43"
db_instance_class         = "db.t3.micro"
db_allocated_storage      = 20
db_name                   = "myapp"
db_username               = "admin"
# db_password             = "your-password"  # Use TF_VAR_db_password env var
db_multi_az               = true
db_storage_encrypted      = true
enable_secrets_manager    = false  # Set to true for production
```

### Enable ElastiCache

```hcl
enable_elasticache       = true
elasticache_engine       = "redis"
elasticache_node_type    = "cache.t3.micro"
elasticache_multi_az     = true
elasticache_automatic_failover = true
```

## Module Details

### VPC Module (`modules/vpc/`)
Creates:
- VPC with custom CIDR
- Public and private subnets across AZs
- Internet Gateway and NAT Gateways
- Route tables

**Variables:**
- `vpc_cidr`
- `public_subnet_cidrs`
- `private_subnet_cidrs`

### Security Module (`modules/security/`)
Creates:
- ALB security group (HTTP/HTTPS)
- ECS tasks security group
- RDS security group (optional)
- ElastiCache security group (optional)

**Variables:**
- `enable_rds`
- `enable_elasticache`

### ALB Module (`modules/alb/`)
Creates:
- Application Load Balancer
- Target group for ECS tasks
- HTTP/HTTPS listeners

**Variables:**
- `app_port`
- `listener_port`
- `enable_https`
- `health_check_path`

### ECS Module (`modules/ecs/`)
Creates:
- ECS cluster with Container Insights
- Task definition
- ECS service
- Auto Scaling policies (CPU & Memory)

**Variables:**
- `container_image`
- `task_cpu`, `task_memory`
- `desired_count`
- `min_capacity`, `max_capacity`
- `environment_variables`, `secrets`

### RDS Module (`modules/rds/`)
Creates:
- RDS instance (optional)
- DB subnet group
- Parameter group
- Secrets Manager secret (optional)

**To Enable:**
Set `enable_rds = true` in terraform.tfvars

### ElastiCache Module (`modules/elasticache/`)
Creates:
- ElastiCache cluster (Redis or Memcached)
- Parameter group
- Subnet group

**To Enable:**
Set `enable_elasticache = true` in terraform.tfvars

## Common Tasks

### Update Container Image

```bash
# Update container_image in terraform.tfvars
terraform apply
```

### Scale Tasks

```bash
# Update desired_count
terraform apply
```

### Enable HTTPS

```hcl
enable_https    = true
certificate_arn = "arn:aws:acm:region:account:certificate/id"
```

### Add Environment Variables

```hcl
environment_variables = [
  {
    name  = "DATABASE_URL"
    value = "postgresql://..."
  },
  {
    name  = "CACHE_URL"
    value = "redis://..."
  }
]
```

### Use RDS with ECS

```hcl
enable_rds = true
enable_secrets_manager = true

# In container configuration
secrets = [
  {
    name      = "DATABASE_URL"
    valueFrom = "arn:aws:secretsmanager:region:account:secret:my-ecs-app/rds/password"
  }
]
```

## Outputs

After applying, useful outputs include:

```bash
alb_dns_name          # URL to access your app
ecs_cluster_name      # ECS cluster name
rds_address           # RDS database address
elasticache_endpoint  # ElastiCache endpoint
```

## Cleanup

```bash
terraform destroy
```

## Best Practices

1. **Sensitive Variables**: Use environment variables for secrets
   ```bash
   export TF_VAR_db_password="your-password"
   ```

2. **Remote State**: Store Terraform state in S3
   ```hcl
   terraform {
     backend "s3" {
       bucket = "your-bucket"
       key    = "ecs/terraform.tfstate"
       region = "us-east-1"
     }
   }
   ```

3. **Production**: Enable deletion protection, multi-AZ, encryption
   ```hcl
   db_multi_az              = true
   db_deletion_protection   = true
   elasticache_multi_az     = true
   elasticache_automatic_failover = true
   ```

4. **Monitoring**: Enable CloudWatch and Container Insights
   ```hcl
   enable_container_insights = true
   log_retention_days        = 30
   ```

## Troubleshooting

### Task Failures
Check logs:
```bash
aws logs tail /ecs/ecs-fargate-microservices --follow
```

### Health Check Failures
Ensure your container responds with HTTP 200 on `health_check_path`

### RDS Connection Issues
- Verify security group allows port 3306 (MySQL)
- Check RDS is in same VPC
- Verify credentials in environment variables or Secrets Manager

### ElastiCache Connection Issues
- Verify security group allows cache port
- Check encryption settings if using auth token

## Additional Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/best-practices.html)
