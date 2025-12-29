resource "aws_eks_addon" "this" {
  cluster_name                = var.cluster_name
  addon_name                  = var.addon_name
  addon_version               = var.auto_version ? null : var.addon_version
  resolve_conflicts_on_create = var.resolve_conflicts
  resolve_conflicts_on_update = var.resolve_conflicts

  configuration_values = var.config_values

  service_account_role_arn = var.use_custom_iam ? aws_iam_role.this[0].arn : null

  tags = var.tags
}