variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "s3_buckets" {
  type = set(string)
}