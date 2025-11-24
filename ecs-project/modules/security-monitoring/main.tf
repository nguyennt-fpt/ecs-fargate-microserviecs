# GuardDuty Detector
resource "aws_guardduty_detector" "main" {
  enable = var.enable_guardduty

  datasources {
    s3_logs {
      enable = var.enable_s3_monitoring
    }
    kubernetes {
      audit_logs {
        enable = false
      }
    }
    malware_protection {
      scan_ec2_instance_with_findings {
        ebs_volumes {
          enable = false
        }
      }
    }
  }

  tags = {
    Name = "${var.project_name}-guardduty"
  }
}

# CloudWatch Log Group for VPC Flow Logs
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  count             = var.enable_vpc_flow_logs ? 1 : 0
  name              = "/aws/vpc/flowlogs/${var.project_name}"
  retention_in_days = var.flow_log_retention_days

  tags = {
    Name = "${var.project_name}-vpc-flow-logs"
  }
}

# IAM Role for VPC Flow Logs
resource "aws_iam_role" "flow_log" {
  count = var.enable_vpc_flow_logs ? 1 : 0
  name  = "${var.project_name}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-vpc-flow-log-role"
  }
}

# IAM Policy for VPC Flow Logs
resource "aws_iam_role_policy" "flow_log" {
  count = var.enable_vpc_flow_logs ? 1 : 0
  name  = "${var.project_name}-vpc-flow-log-policy"
  role  = aws_iam_role.flow_log[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Resource = "*"
      }
    ]
  })
}

# VPC Flow Logs
resource "aws_flow_log" "vpc" {
  count           = var.enable_vpc_flow_logs ? 1 : 0
  iam_role_arn    = aws_iam_role.flow_log[0].arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log[0].arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id

  tags = {
    Name = "${var.project_name}-vpc-flow-logs"
  }
}

# SNS Topic for Security Alerts
resource "aws_sns_topic" "security_alerts" {
  count = var.enable_guardduty ? 1 : 0
  name  = "${var.project_name}-security-alerts"

  tags = {
    Name = "${var.project_name}-security-alerts"
  }
}

# SNS Email Subscription
resource "aws_sns_topic_subscription" "email_alerts" {
  count     = var.enable_guardduty && var.security_alert_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.security_alerts[0].arn
  protocol  = "email"
  endpoint  = var.security_alert_email
}

# GuardDuty CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "guardduty_findings" {
  count       = var.enable_guardduty ? 1 : 0
  name        = "${var.project_name}-guardduty-findings"
  description = "Capture high severity GuardDuty findings"

  event_pattern = jsonencode({
    source      = ["aws.guardduty"]
    detail-type = ["GuardDuty Finding"]
    detail = {
      severity = [{
        numeric = [">=", 7.0]
      }]
    }
  })

  tags = {
    Name = "${var.project_name}-guardduty-findings"
  }
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "sns" {
  count     = var.enable_guardduty ? 1 : 0
  rule      = aws_cloudwatch_event_rule.guardduty_findings[0].name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.security_alerts[0].arn

  input_transformer {
    input_paths = {
      severity    = "$.detail.severity"
      type        = "$.detail.type"
      region      = "$.detail.region"
      account     = "$.detail.accountId"
      time        = "$.detail.updatedAt"
      description = "$.detail.description"
    }
    input_template = <<EOF
{
  "Alert": "🚨 SECURITY THREAT DETECTED 🚨",
  "Severity": "<severity>",
  "Type": "<type>",
  "Account": "<account>",
  "Region": "<region>",
  "Time": "<time>",
  "Description": "<description>",
  "Action": "Please investigate immediately in AWS GuardDuty console"
}
EOF
  }
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "security_alerts" {
  count = var.enable_guardduty ? 1 : 0
  arn   = aws_sns_topic.security_alerts[0].arn

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "events.amazonaws.com"
        }
        Action   = "SNS:Publish"
        Resource = aws_sns_topic.security_alerts[0].arn
      }
    ]
  })
}