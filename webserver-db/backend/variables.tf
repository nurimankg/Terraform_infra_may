variable "env" {
  type    = string
  default = "dev"
}
variable "internet_access" {
  type = list(string)
}
variable "db_port" {
  type = number
}

variable "snapshot" {
  type    = bool
  default = true
}