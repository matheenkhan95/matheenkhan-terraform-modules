output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "node_groups" {
  value = { for k, v in aws_eks_node_group.groups : k => v.id }
}