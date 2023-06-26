variable "count_of_resource" {
  description = "Count of AWS resources to create."
  type        = number
  default     = 1
}

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
