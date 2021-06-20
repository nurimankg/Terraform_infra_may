########### AMI of instances 

data "aws_ami" "Centos" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS**"]
  }

  filter {
    name   = "product-code"
    values = ["*aw0evgkw8e5c1q413zgy5pjce*"]
  }
}

############# Template files

data "template_file" "user_data" {
  template = file("userdata.sh")
  vars = {
    environment = var.env
  }
}

############# Fetching the Remote State file

# data "terraform_remote_state" "rds" {
#   backend = "s3"
#   config = {
#     bucket = "backend-tfvars"
#     key    = "webserver-db/frontend/terraform.tfvars"
#     region = "us-east-1"
#   }
# }