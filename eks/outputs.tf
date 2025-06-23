output "eks_cluster_name" {
  value = aws_eks_cluster.default.name
}

output "eks_cluster_endpoint" {
  value = aws_eks_cluster.default.endpoint
}

# output "eks_node_group_name" {
#   value = aws_eks_node_group.default.node_group_name
# }
