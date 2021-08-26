output "cluster_name" {
  value = local.is_eks_cluster_exist ? var.cluster_name : module.eks.cluster_id
}
