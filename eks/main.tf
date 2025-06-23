resource "aws_eks_cluster" "default" {
  name = var.name

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"

  vpc_config {
    endpoint_private_access = true
    endpoint_public_access  = true

    subnet_ids         = var.private_subnets
    security_group_ids = [aws_security_group.eks-cluster.id]
  }


  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

resource "aws_security_group" "eks-cluster" {
  name        = "terraform-eks-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "EKS - kubernetes master sg"
  }
}


# resource "aws_security_group_rule" "eks-cluster-ingress-node-https" {
#   description              = "Allow pods to communicate with the cluster API Server"
#   from_port                = 443
#   protocol                 = "tcp"
#   security_group_id        = "${aws_security_group.eks-cluster.id}"
#   source_security_group_id = "${aws_security_group.eks-node.id}"
#   to_port                  = 443
#   type                     = "ingress"
# }
