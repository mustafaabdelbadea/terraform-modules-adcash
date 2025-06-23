variable "name" {
  type    = string
  default = "main"
}

variable "nodegroup_name" {
  type    = string
  default = "main"
}

variable "min_capacity" {
  type    = number
  default = 2
}

variable "max_capacity" {
  type    = number
  default = 2
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "max_unavailable" {
  type    = number
  default = 1
}

variable "private_subnets" {
  type = set(string)
}

variable "vpc_id" {
  type = string
}
variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "capacity_type" {
  type    = string
  default = "SPOT"
}


variable "nodes-stack-name" {
  type    = string
  default = "eks-cluster-stack"
}

variable "node-group-parameters" {
  type = map(any)
  default = {
    NodeGroupName                       = "your-node-group"
    NodeAutoScalingGroupMinSize         = 1
    NodeAutoScalingGroupDesiredCapacity = 3
    NodeAutoScalingGroupMaxSize         = 30
    NodeInstanceType                    = "t3.medium"
  }
}
