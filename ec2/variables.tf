variable "template_name" {
  description = "Template name"
  type        = string
  default     = "main"
}

variable "image_id" {
  description = "Image id for the ec2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "desired_capacity" {
  description = "Desired capacity for ec2 instance"
  type        = number
  default     = 1
}

variable "min_size" {
  description = "Min capacity for ec2 instance"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Max capacity for ec2 instance"
  type        = number
  default     = 2
}

variable "project" {
  type    = string
  default = "Main"
}

variable "private_subnets" {
  type = set(string)
}

variable "public_subnets" {
  type = set(string)
}

variable "vpc_id" {
  type = string
}

variable "loadbalancer_dns" {
  type = string
}
