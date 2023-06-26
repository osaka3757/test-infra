locals {
  project_name             = "cds"
  env                      = terraform.workspace
  frontend_repository_path = "osaka3757/cds-customer-frontend"
}

variable "profile" {
  type = string
}
