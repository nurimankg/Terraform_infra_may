resource "aws_key_pair" "terraform_server" {
  key_name   = "${var.env}-terraform_server"
  public_key = file("~/.ssh/id_rsa.pub")
}