locals {
  frontend_repository_path = "osaka3757/cds-customer-frontend"
}

variable "project_name" {
  type = string
}

variable "env" {
  type    = string
  default = "dev"
}

variable "profile" {
  type = string
}
