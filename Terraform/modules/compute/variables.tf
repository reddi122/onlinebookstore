variable "subnet_id" {}
variable "ami_id" {}
variable "key_name" {}

variable "security_groups" {
  type = map(string)
}


variable "iam_instance_profile" {
  type = string
}
