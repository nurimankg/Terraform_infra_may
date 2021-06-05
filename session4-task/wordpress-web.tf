## webserver instance

resource "aws_instance" "webserver" {
    ami = data.aws_ami.Amazon_linux.id
    instance_type = var.instance
    vpc_security_group_ids = [aws_security_group.webserver_sg.id]
    subnet_id = aws_subnet.public_subnets.0.id
    key_name = aws_key_pair.tf_key.key_name
    user_data = data.template_file.user_data.rendered
    associate_public_ip_address = "true"

    tags = {
      "Name" = "${var.env}-web"
    }

      root_block_device {
      delete_on_termination = true
  }
}

## AMI

data "aws_ami" "Amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }
}

## Template file for wordpress 

data "template_file" "user_data" {
    template = file("user_data.sh")
    vars = {
        env = var.env
    }
}
## Security groups

resource "aws_security_group" "webserver_sg" {
  name        = "${var.env}-webserver-sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port        = var.webserver_port
    to_port          = var.webserver_port
    protocol         = "tcp"
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr
  }

  tags = {
    Name = "allow_http"
  }
}

## Key pairs

resource "aws_key_pair" "tf_key" {
  key_name   = "terraform-server-key"
  public_key = file("~/.ssh/id_rsa.pub")
 }
