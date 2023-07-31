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

variable "customer_app_title" {
  type = string
}

variable "cognito_customer_resion_name" {
  type = string
}

variable "cognito_customer_client_id" {
  type = string
}

variable "cognito_customer_client_secret" {
  type = string
}

variable "customer_cors_origins" {
  type = string
}

variable "cognito_account_manager_resion_name" {
  type = string
}

variable "cognito_account_manager_client_id" {
  type = string
}

variable "cognito_account_manager_client_secret" {
  type = string
}
