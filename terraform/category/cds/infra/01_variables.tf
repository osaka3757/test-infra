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

variable "customer_app_title" {
  type = string
}

variable "cognito_customer_region_name" {
  type = string
}

variable "cognito_customer_client_id" {
  type = string
}

variable "cognito_customer_client_secret" {
  type = string
}

variable "customer_origin_whitelist" {
  type = string
}

variable "account_manager_app_title" {
  type = string
}

variable "cognito_account_manager_region_name" {
  type = string
}

variable "cognito_account_manager_client_id" {
  type = string
}

variable "cognito_account_manager_client_secret" {
  type = string
}

variable "cognito_account_manager_user_pool_id" {
  type = string
}

variable "account_manager_origin_whitelist" {
  type = string
}
