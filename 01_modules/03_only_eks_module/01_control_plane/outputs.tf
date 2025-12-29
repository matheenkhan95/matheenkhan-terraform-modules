output "cluster_name" {
  description = "Name of the created EKS cluster"
  value       = aws_eks_cluster.this.name
}
