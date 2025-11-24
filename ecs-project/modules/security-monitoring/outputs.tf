output "guardduty_detector_id" {
  description = "GuardDuty detector ID"
  value       = var.enable_guardduty ? aws_guardduty_detector.main.id : null
}

output "vpc_flow_log_id" {
  description = "VPC Flow Log ID"
  value       = var.enable_vpc_flow_logs ? aws_flow_log.vpc[0].id : null
}

output "security_alerts_topic_arn" {
  description = "SNS topic ARN for security alerts"
  value       = var.enable_guardduty ? aws_sns_topic.security_alerts[0].arn : null
}