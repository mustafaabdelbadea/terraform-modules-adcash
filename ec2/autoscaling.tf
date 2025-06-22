

resource "aws_launch_template" "default" {
  name_prefix   = var.template_name
  image_id      = var.image_id
  instance_type = var.instance_type

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 8
    }
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.default.id]
  }

  user_data = data.cloudinit_config.default.rendered
  key_name  = "eks_kp"

  # vpc_security_group_ids = [aws_security_group.default.id]

  tags = {
    Name    = "MainTemplate",
    Project = var.project
  }
}

resource "aws_autoscaling_group" "default" {
  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }
}
