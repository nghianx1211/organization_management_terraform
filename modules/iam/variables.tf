variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "dev_policy_resources" {
  type = map(list(string))
}

variable "devops_policy_resources" {
  type = map(list(string))
}

variable "backend_policy_resources" {
  type = map(list(string))
}