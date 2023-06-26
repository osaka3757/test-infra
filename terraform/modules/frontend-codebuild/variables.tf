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
