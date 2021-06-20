variable "env" {
  type = string
}

variable "vpc_id" {
  type = list(string)
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "public_subnet_cidr" {
  type = list(string)
}

variable "subnet_az" {
  type = list(string)

}

variable "custom_ip" {
  type = list(string)
}

variable "all_internet" {
  type = list(string)
}
variable "internet_access" {
  type = string
}

variable "instance" {
  type = string
}

variable "webserver_port_http" {
  type = number
}

variable "webserver_port_ssh" {
  type = number
}