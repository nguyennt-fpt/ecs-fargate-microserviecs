# AWS ECS Fargate Microservices Infrastructure

This project provides infrastructure as code (IaC) to deploy microservices applications on AWS ECS Fargate with supporting services like RDS, ElastiCache, WAF, and monitoring.

## 🏗️ Architecture

### ECS Project
- **ECS Fargate**: Container orchestration with auto scaling
- **Application Load Balancer**: Load balancing and health checks
- **VPC Endpoints**: Private connectivity to AWS services (ECR, Secrets Manager, S3, CloudWatch)
- **RDS MySQL**: Managed database with encryption
- **ElastiCache Redis**: In-memory caching (optional)
- **AWS WAF**: Web application firewall
- **Security Monitoring**: GuardDuty, VPC Flow Logs, SNS alerts
- **Secrets Manager**: Secure credentials management

### Getting Started App
- Node.js application with Docker
- CI/CD pipeline with AWS CodeBuild
- Docker Compose for local development

## 📁 Project Structure

```
Terraform/
├── ecs-project/                 # Main infrastructure
│   ├── modules/                 # Terraform modules
│   │   ├── alb/                # Application Load Balancer
│   │   ├── ecs/                # ECS Fargate cluster & service
│   │   ├── ecr-endpoint/       # VPC Endpoints for ECR, S3, Secrets Manager
│   │   ├── iam/                # IAM roles and policies
│   │   ├── rds/                # RDS MySQL database
│   │   ├── security/           # Security groups
│   │   ├── vpc/                # VPC, subnets (no NAT Gateway)
│   │   ├── waf/                # AWS WAF protection
│   │   ├── elasticache/        # ElastiCache Redis (optional)
│   │   ├── secrets/            # Secrets Manager
│   │   └── security-monitoring/ # GuardDuty, VPC Flow Logs
│   ├── main.tf                 # Main configuration
│   ├── variables.tf            # Input variables
│   ├── outputs.tf              # Output values
│   └── terraform.tfvars.example # Configuration template
├── getting-started-app/         # Sample Node.js application
│   ├── src/                    # Application source code
│   ├── Dockerfile              # Container definition
│   ├── buildspec.yml           # CodeBuild configuration
│   └── package.json            # Node.js dependencies
└── README.md                   # This file
```

## 🚀 Getting Started

### Prerequisites

1. **AWS CLI** configured
```bash
aws configure
```

2. **Terraform** >= 1.0
```bash
# Windows
choco install terraform

# macOS
brew install terraform
```

3. **Docker** (for local development)
4. **ECR Repository** created for your container images

### Deploy Infrastructure

1. **Clone repository**
```bash
git clone <repository-url>
cd Terraform/ecs-project
```

2. **Create configuration file**
```bash
cp terraform.tfvars.example terraform.tfvars
```

3. **Edit terraform.tfvars**
```hcl
# Update the following values:
aws_region = "ap-southeast-1"
project_name = "your-project-name"
container_image = "YOUR_ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/YOUR_IMAGE:latest"
security_alert_email = "your-email@example.com"

# Database settings
enable_rds = true
enable_secrets_manager = true

# Optional features
enable_elasticache = false
enable_waf = true
```

4. **Initialize Terraform**
```bash
terraform init
```

5. **Review plan**
```bash
terraform plan
```

6. **Deploy**
```bash
terraform apply
```

### Deploy Application

1. **Build and push Docker image**
```bash
cd ../getting-started-app

# Build image
docker build -t your-app .

# Tag and push to ECR
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.ap-southeast-1.amazonaws.com
docker tag your-app:latest YOUR_ACCOUNT_ID.dkr.ecr.ap-southeast-1.amazonaws.com/your-repo:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.ap-southeast-1.amazonaws.com/your-repo:latest
```

2. **Update ECS service** (automatic after pushing new image)

## ⚙️ Configuration

### VPC Endpoints (Cost Optimization)

```hcl
# VPC Endpoints replace NAT Gateway
# Automatically created:
# - ECR API endpoint
# - ECR DKR endpoint  
# - S3 Gateway endpoint
# - Secrets Manager endpoint
# - CloudWatch Logs endpoint (optional)
```

### Optional Features

```hcl
# Database
enable_rds = true
enable_secrets_manager = true

# Caching
enable_elasticache = false

# Security
enable_waf = true
enable_guardduty = true
enable_vpc_flow_logs = true
```

### Auto Scaling

```hcl
desired_count = 2
min_capacity = 2
max_capacity = 4
target_cpu_utilization = 70
target_memory_utilization = 80
```

## 🔒 Security

- **VPC Endpoints**: Private connectivity, no internet access for containers
- **Encryption**: RDS and ElastiCache are encrypted
- **Secrets Manager**: Secure credential management
- **WAF**: Protection against web attacks
- **GuardDuty**: Threat detection
- **VPC Flow Logs**: Network traffic monitoring
- **Security Groups**: Network access control
- **No NAT Gateway**: Enhanced security and cost savings

## 📊 Monitoring

- **CloudWatch Logs**: Application and container logs (via VPC endpoint)
- **Container Insights**: ECS metrics
- **GuardDuty**: Security monitoring
- **SNS Alerts**: Email notifications for security events
- **VPC Flow Logs**: Network traffic analysis

## 🧹 Cleanup

```bash
cd ecs-project
terraform destroy
```

## 📝 Important Notes

- **Cost Savings**: No NAT Gateway (~$45/month savings)
- **Enhanced Security**: Containers have no internet access
- `terraform.tfvars` contains sensitive information, do not commit to Git
- Use `terraform.tfvars.example` as template
- ECR repository must exist before deployment
- VPC endpoints provide private connectivity to AWS services
- Backup terraform state file regularly

## 🆘 Troubleshooting

### Common Issues

1. **ECR repository does not exist**
```bash
aws ecr create-repository --repository-name your-repo-name
```

2. **Container cannot pull image**
- Ensure VPC endpoints are created
- Check security groups allow port 443
- Verify IAM roles have ECR permissions

3. **Secrets Manager connection issues**
- Ensure Secrets Manager VPC endpoint exists
- Check private DNS is enabled on endpoints

4. **Insufficient permissions**
- Check IAM permissions for Terraform
- Ensure permissions to create VPC endpoints, ECS, RDS, etc.

5. **Resource limits**
- Check service quotas in AWS console
- Request limit increases if needed

## 📞 Support

If you encounter issues, please create an issue or contact the DevOps team.