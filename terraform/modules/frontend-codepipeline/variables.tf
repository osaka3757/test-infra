variable "project_name" {
  type = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "required project name."
  }
}

variable "env" {
  type = string
}

variable "frontend_repository_path" {
  type = string
}

variable "codebuild_name" {
  type = string
}
