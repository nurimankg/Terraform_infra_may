############## Launch configuration

resource "aws_launch_configuration" "webserver_lc" {
  name_prefix     = "${var.env}-web-lc-"
  image_id        = data.aws_ami.Centos.id
  instance_type   = var.instance
  security_groups = [aws_security_group.instance_sg.id]
  key_name        = aws_key_pair.terraform_server.key_name
  user_data       = data.template_file.user_data.rendered

  root_block_device {
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

###########  Provisioner installing app

# provisioner "file" {
#     connection {
#       type        = "ssh"
#       user        = "ec2-user"
#       host        = self.public_ip
#       private_key = file("/home/ec2-user/.ssh/id_rsa")
#     }
#     source = "index.html"
#     destination = "/tmp/index.html"
#   }

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ec2-user"
#       host        = self.public_ip
#       private_key = file("/home/ec2-user/.ssh/id_rsa")
#     }
#     inline = [
#       "sudo yum install httpd -y",
#       "sudo mv /tmp/index.html /var/www/html/index.html",
#       "sudo systemctl start httpd"
#     ]
#   }

########## SG for instance

resource "aws_security_group" "instance_sg" {
  name        = "${var.env}-instance-sg"
  description = "first sg created by tf"
  ingress {
    from_port       = var.webserver_port_http
    to_port         = var.webserver_port_http
    protocol        = "tcp"
    security_groups = [aws_security_group.webserver_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.all_internet
  }
}

###########  AutoScaling group

resource "aws_autoscaling_group" "webserver_asg" {
  name                      = aws_launch_configuration.webserver_lc.name
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 90
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = false
  launch_configuration      = aws_launch_configuration.webserver_lc.name
  vpc_zone_identifier       = var.public_subnet_cidr
  wait_for_elb_capacity     = 1
  wait_for_capacity_timeout = "5m"

  instance_refresh {
    strategy = "Rolling" # deployment strategy - create new one and delete old one
    preferences {
      min_healthy_percentage = 50
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

##############  AutoScaling attachments

resource "aws_autoscaling_attachment" "web_lb_attachment" {
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.id
  alb_target_group_arn   = aws_lb_target_group.webserver_tg.arn
}

