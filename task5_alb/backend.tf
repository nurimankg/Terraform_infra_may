terraform {
  backend "s3" {
    bucket = "terraform-state-vars"
    key    = "remote/dev/terraform.tfvars"
    region = "us-east-1"
  }
}