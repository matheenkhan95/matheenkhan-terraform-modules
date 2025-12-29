output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks_control_plane.cluster_name
}