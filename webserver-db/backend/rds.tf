resource "aws_db_instance" "rds" {
  allocated_storage         = 10
  storage_type              = "gp2"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t2.micro"
  identifier                = "${var.env}-db-instance"
  name                      = "wordpress-web"
  username                  = "admin"
  password                  = random_password.password.result
  skip_final_snapshot       = var.snapshot                                        
  final_snapshot_identifier = var.snapshot == true ? null : "${var.env}-snapshot" 
  publicly_accessible = var.env == "dev" ? true : false
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_security_group" "rds_sg" {
  name        = "${var.env}-rds-sg"
  description = "Allow MySQL"

  ingress {
    description = "This is for MySQL"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = var.all_internet
  }

  egress {
    description = "ALL ports and protocols"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = var.all_internet
  }
}