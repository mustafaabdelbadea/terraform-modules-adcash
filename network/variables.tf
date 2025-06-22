variable "vpc_name" {
  type    = string
  default = "main"
}

variable "vpc_main_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "project" {
  type    = string
  default = "adcash"
}
