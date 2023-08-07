variable "cds_account_manager_frontend_repository_path" {
  type = string
}

variable "account_manager_app_title" {
  type = string
}

variable "account_manager_origin_whitelist" {
  type = string
}

variable "cognito_account_manager_region_name" {
  type = string
}

variable "cognito_customer_region_name" {
  type = string
}

variable "account_manage_prefix" {
  type = string
}

variable "branch" {
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
