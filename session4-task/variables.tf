variable "env" {
  type = string
description = "This is a variable for environment"
}

variable "cidr" {
  type = string
}

# variable "instance" {
#   type = string
# }

# variable "webserver_port" {
#   type = number
# }

variable "private_subnet_cidr" {
    type = list(string)
}

variable "public_subnet_cidr" {
    type = list(string)
}

variable "subnet_az" {
    type = list(string)
}