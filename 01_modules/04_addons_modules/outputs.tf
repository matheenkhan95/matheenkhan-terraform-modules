output "addon_name" {
  description = "The name of the EKS add-on"
  value       = aws_eks_addon.this.addon_name
}

output "addon_version" {
  description = "The version of the EKS add-on"
  value       = aws_eks_addon.this.addon_version
}
/*
output "addon_status" {
  description = "The status of the EKS add-on"
  value       = aws_eks_addon.this.addon_status
}
*/
output "addon_arn" {
  description = "The ARN of the EKS add-on"
  value       = aws_eks_addon.this.arn
}

output "addon_service_role" {
  description = "The IAM role ARN used by the add-on"
  value       = aws_eks_addon.this.service_account_role_arn
}
