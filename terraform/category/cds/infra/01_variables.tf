locals {
  frontend_repository_path = "osaka3757/cds-customer-frontend"
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

variable "customer_cognito_resion_name" {
  type = string
}

variable "customer_cognito_client_id" {
  type = string
}

variable "customer_cognito_client_secret" {
  type = string
}

variable "account_manager_cognito_resion_name" {
  type = string
}

variable "account_manager_cognito_client_id" {
  type = string
}

variable "account_manager_cognito_client_secret" {
  type = string
}
