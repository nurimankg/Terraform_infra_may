resource "aws_launch_configuration" "webserver_lc" {
  name_prefix     = "${var.env}-webserver_lc-"
  image_id        = data.aws_ami.Centos.id
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.tf_key.id

  root_block_device {
    delete_on_termination = true
  }

  user_data = data.template_file.user-data.rendered

}


####### Data source for ami

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

data "template_file" "user-data" {
  template = file("user_data.sh")
  vars = {
    env = var.env
  }
}

####### Security group

# resource "aws_security_group" "sg_ec2" {
#   name        = "${var.env}-instance-sg"
#   description = "sg created by tf"
#   vpc_id = aws_vpc.main_vpc.id

#   ingress {
#     from_port       = 80
#     to_port         = 80
#     protocol        = "tcp"
#     security_groups = var.all_internet
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = var.all_internet
#   }
# }

#### Key pair

resource "aws_key_pair" "tf_key" {
  key_name   = "${var.env}-Terraform_lb_key"
  public_key = file("~/.ssh/id_rsa.pub")
}