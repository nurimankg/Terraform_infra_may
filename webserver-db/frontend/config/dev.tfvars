env                 = "dev"
instance            = "t2.micro"
snapshot            = "true"

vpc_cidr            = "10.0.0.0/16"
vpc_id              = ["10.0.0.0/16"]
public_subnet_cidr  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidr = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
subnet_az           = ["us-east-1a", "us-east-1b", "us-east-1c"]
internet_access     = "0.0.0.0/0"
custom_ip           = ["???"]
all_internet        = ["0.0.0.0/0"]
webserver_port_http = 80
webserver_port_ssh  = 22
db_port             = 3306