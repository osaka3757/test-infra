variable "profile" {
  type = string
}

variable "project_name" {
  type = string
}

variable "env" {
  type    = string
  default = "dev"
}

variable "project_prefix" {
  type = string
}

variable "customer_prefix" {
  type = string
}

variable "account_manage_prefix" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnet_1a_cidr_block" {
  type = string
}

variable "public_subnet_1c_cidr_block" {
  type = string
}

variable "private_subnet_1a_cidr_block" {
  type = string
}

variable "private_subnet_1c_cidr_block" {
  type = string
}
