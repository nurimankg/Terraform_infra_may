############  App load balancer

resource "aws_lb" "webserver_lb" {
  name               = "${var.env}-webserver-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webserver_sg.id]
  subnets            = var.public_subnet_cidr
  tags               = local.common_tags

}

##############  SG for load balancer

resource "aws_security_group" "webserver_sg" {
  name        = "${var.env}-webserver-sg"
  description = "first sg created by tf"
  ingress {
    from_port   = var.webserver_port_http
    to_port     = var.webserver_port_http
    protocol    = "tcp"
    cidr_blocks = var.all_internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.all_internet
  }
}

#############  Target group for alb

resource "aws_lb_target_group" "webserver_tg" {
  name     = "${var.env}-web-tg"
  port     = var.webserver_port_http
  protocol = "HTTP"
  vpc_id   = var.internet_access
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = 80
    healthy_threshold   = 2
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = local.common_tags
}

##############  Listners for alb

resource "aws_lb_listener" "webserver_listner" {
  load_balancer_arn = aws_lb.webserver_lb.arn
  port              = var.webserver_port_http
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}