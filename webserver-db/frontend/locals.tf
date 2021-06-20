locals {
  common_tags = {
    env     = var.env
    project = "${var.env}-wordpress"
    team    = "DevOps"
    owner   = "Nur"
  }
}