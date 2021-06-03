resource "aws_instance" "first_ec2" {
  count = 2               # var.instance_type make variable. we use count if instances are identical to each other
  ami           = "ami-0"
  instance_type = var.instance

  lifecycle {
    create_before_destroy = true
    #prevent_destroy = true   # if we don't want to destoy database
    #ignore_changes = []
  }
  

  tags = {
    Name = "${var.env}-webserver-${count.index}", # "Test${count.index}"
    Evironment = var.env
  }
# provider "aws" {     # if we want to spin up only some resources in different region but under resource "aws_instance" "name of instance in dif region" {  we need add line ->provider = aws.east(name of different region)
#   alias = "east"
#   region = "us-east-2"
# }

  # output "instance" {
  #   value = "aws_instance.first_ec2[*].public_ip"  # [*] will give output of all instance ip addresses
  # }                                                # or we can for loop -> [for instance in aws_instance.web : instance.public_ip]

  root_block_device {
    delete_on_termination = true
  }
}

  user_data = data.template_file.user_data.rendered

  vpc_security_group_ids = [aws_security_group.first_sg.id]


  resource "aws_security_group" "first_sg" {
    name        = "${var.env}-webserver-sg"
    description = "Allow http inbound traffic"

    ingress {
      from_port   = var.webserver_port
      to_port     = var.webserver_port
      protocol    = "tcp"
      cidr_blocks = var.cidr
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = var.cidr
    }

    tags = {
      Name = "allow_http"
    }
  }

  data "template_file" "user_data" {
      template = file("user-data.sh")
      vars = {
        env = var.env
      }
  }