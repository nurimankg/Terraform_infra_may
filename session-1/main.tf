resource "aws_instance" "web" {
  count = 2  
  ami           = var.ami
  instance_type = var.instance

  tags = {
    Name = "${var.instance}-webserver-${count.index}"
  }
}

root_block_device { 
    delete_on_termination = true
}

lifecycle {
    create_before_destroy = true
}