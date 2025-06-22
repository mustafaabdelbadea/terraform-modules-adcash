resource "aws_security_group" "default" {
  name        = "prometheus_sg"
  description = "Allow prometheus:9090 inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "MainSecurityGroup",
    Project = var.project
  }
}

resource "aws_security_group_rule" "prometheus_ingress" {
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "ssh_ingress" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "default_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}
