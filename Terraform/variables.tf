variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.0.0/28"
}

variable "az" {
  default = "us-west-1a"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
}

variable "key_name" {
  description = "EC2 key pair name"
}
