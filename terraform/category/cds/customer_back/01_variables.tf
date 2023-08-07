variable "cds_customer_frontend_repository_path" {
  type = string
}

variable "cds_customer_back_repository_path" {
  type = string
}

variable "customer_app_title" {
  type = string
}

variable "cognito_customer_region_name" {
  type = string
}

variable "customer_origin_whitelist" {
  type = string
}

variable "customer_prefix" {
  type = string
}

variable "state_bucket" {
  type = string
}

variable "github_account" {
  type = string
}

variable "branch" {
  type = string
}

variable "github_secret_token" {
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
