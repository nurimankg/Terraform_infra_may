terraform {
  backend "s3" {
    bucket = "backend-tfvars"
    key    = "webserver-db/backend/terraform.tfvars"
    region = "us-east-1"
  }
}