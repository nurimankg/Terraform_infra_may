locals {
  common_tags = {
    env     = var.env
    project = "${var.env}-wordpress"
    team    = "DevOps"
    owner   = "Nur"
  }
}

locals {
  webserver_port = 80
  protocol       = "tcp"
}