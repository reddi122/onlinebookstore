terraform {
  backend "s3" {
    bucket         = "terraform-state-reddi"
    key            = "dev/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-lock-reddi"
    encrypt        = true
  }
}
