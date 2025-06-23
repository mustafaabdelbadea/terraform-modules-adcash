# resource "aws_eks_node_group" "default" {
#   cluster_name    = aws_eks_cluster.default.name
#   node_group_name = var.nodegroup_name
#   node_role_arn   = aws_iam_role.nodes.arn
#   subnet_ids      = var.private_subnets
#   capacity_type   = var.capacity_type

#   scaling_config {
#     desired_size = var.desired_capacity
#     max_size     = var.max_capacity
#     min_size     = var.min_capacity
#   }

#   update_config {
#     max_unavailable = var.max_unavailable
#   }

#   instance_types = var.instance_types

#   depends_on = [
#     aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
#   ]
# }


# resource "aws_security_group" "eks-node" {
#   name        = "eks-worker-node"
#   description = "Security group for all nodes in the cluster"
#   vpc_id      = var.vpc_id

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#      "Name" = "eks-worker-node-sg",
#      "kubernetes.io/cluster/${var.name}" = "owned"
#   }
# }

# resource "aws_security_group_rule" "eks-node-ingress-self" {
#   description              = "Allow node to communicate with each other"
#   from_port                = 0
#   protocol                 = "-1"
#   security_group_id        = "${aws_security_group.eks-node.id}"
#   source_security_group_id = "${aws_security_group.eks-node.id}"
#   to_port                  = 65535
#   type                     = "ingress"
# }

# resource "aws_security_group_rule" "eks-node-ingress-cluster" {
#   description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
#   from_port                = 1025
#   protocol                 = "tcp"
#   security_group_id        = "${aws_security_group.eks-node.id}"
#   source_security_group_id = "${aws_security_group.eks-cluster.id}"
#   to_port                  = 65535
#   type                     = "ingress"
# }

# # HPA requires 443 to be open for k8s control plane.
# resource "aws_security_group_rule" "eks-node-ingress-hpa" {
#   description              = "Allow HPA to receive communication from the cluster control plane"
#   from_port                = 443
#   protocol                 = "tcp"
#   security_group_id        = "${aws_security_group.eks-node.id}"
#   source_security_group_id = "${aws_security_group.eks-cluster.id}"
#   to_port                  = 443
#   type                     = "ingress"
# }



resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "pem_file" {
  filename        = pathexpand("~/.ssh/eks-aws.pem")
  file_permission = "600"
  content         = tls_private_key.key_pair.private_key_pem
}

resource "aws_key_pair" "eks_kp" {
  key_name   = "eks_kp"
  public_key = trimspace(tls_private_key.key_pair.public_key_openssh)
}

resource "aws_cloudformation_stack" "cluster-nodes-stack" {
  name          = var.nodes-stack-name
  template_body = file("templates/node-group.yaml")

  parameters = merge(
    var.node-group-parameters,
    {
      ClusterName                      = var.name
      KeyName                          = "eks_kp"
      ClusterControlPlaneSecurityGroup = aws_eks_cluster.default.vpc_config[0].cluster_security_group_id
      VpcId                            = var.vpc_id

      # The type in the template is "List" which is actually a comma separated
      # string list for cloudformation not a terraform list.
      Subnets = join(",", var.private_subnets)
    }
  )

  capabilities = [
    "CAPABILITY_IAM"
  ]

  depends_on = [
    aws_key_pair.eks_kp,
    aws_eks_cluster.default
  ]
}
