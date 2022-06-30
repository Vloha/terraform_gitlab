variable "vpc_cidr" {
  type = string
  description = "The IP range to use for the VPC"
  default = "192.168.0.0/24"
}
