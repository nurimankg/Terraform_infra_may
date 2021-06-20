terraform {
  backend "s3" {
    bucket = "backend-tfvars"
    key    = "webserver-db/frontend/terraform.tfvars"
    region = "us-east-1"
  }
}