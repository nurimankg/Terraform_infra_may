terraform {
  backend "s3" {
    bucket = "stage.tfstage"
    key    = "remote/terraform.tfvars"
    region = "us-east-1"
  }
}

#  lifecycle {
#       prevent_destroy = true
#   }