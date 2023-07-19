locals {
  frontend_repository_path = "osaka3757/cds-customer-frontend"
}

variable "customer_prefix" {
  type = string
}

variable "state_bucket" {
  type = string
}

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

variable "allowed_ip_address" {
  type = list(string)
}

variable "denied_ip_address" {
  type = list(string)
}
