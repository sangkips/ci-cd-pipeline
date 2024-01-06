# Region to house the resources
variable "region" {
  default = "us-east-1"
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "ami" {
  description = "AMI"
  type        = string
  default     = "ami-0c7217cdde317cfec"
}

variable "vpc-cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = {
    "public_subnet-1" = 1
    "public_subnet-1" = 2
    "public_subnet-1" = 3

  }
}

variable "private_subnets" {
  default = {
    "private_subnet-1" = 1
    "private_subnet-1" = 2
    "private_subnet-1" = 3
  }
}

variable "cidt" {
  type    = string
  default = "0.0.0.0/0"
}