############ Webserver

resource "aws_instance" "wordpress-web" {
  ami           = data.aws_ami.Amazon_linux.id
  instance_type = var.instance
  subnet_id = aws_subnet.public_subnet.0.id
  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data = data.template_file.user_data.rendered
  key_name = aws_key_pair.tf_key.id
  associate_public_ip_address = true
  


  tags = {
    Name = "wordpress"
  }
}

####### Data source for ami

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

data "template_file" "user_data" {
  template = file("user_data.sh")
  vars = {
    "env" = "var.env"
  }
}

####### Security groups

resource "aws_security_group" "webserver_sg" {
  name        = "${var.env}-wordpress_sg"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description      = "allow http"
    from_port        = var.webserver_port_http
    to_port          = var.webserver_port_http
    protocol         = "tcp"
    cidr_blocks      = var.vpc_id
  }

    ingress {
    description      = "allow ssh"
    from_port        = var.webserver_port_ssh
    to_port          = var.webserver_port_ssh
    protocol         = "tcp"
    cidr_blocks      = var.vpc_id
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
  }

  tags = {
    Name = "wordpress_sg"
  }
}


#### Key pair

resource "aws_key_pair" "tf_key" {
  key_name   = "${var.env}-Terraform_server_key"
  public_key = file("~/.ssh/id_rsa.pub")
}