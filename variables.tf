variable "aws_region" {
  description = "Region for the VPC"
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default = "10.0.1.0/24"
}

variable "username" {
  description = "IPv6 Username"
  default = "KEY"
}
variable "ipv6_machine" {
  description = "ipv6 machine"
  default = "KEY"
}

variable "ami" {
  description = "Amazon Linux AMI"
  default = "ami-2d39803a"
}

variable "rsa_key" {
  description = "SSH Key for the VPC"
  default = "PUBLIC KEY"
}
variable "keyname" {
  description = "SSH Key for the VPC"
  default = "KEYNAME"
}
variable "ipv6-machine" {
  description = "Shortcut name for ipv6 end machine"
  default = "heap"
}
variable "public_key" {
    description =  "Public Key"
    default =  "KEY"
}
