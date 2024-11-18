variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "frontend_sg_cidr_blocks" {
  type = list(object({
    name    = string
    ingress = map(list(string))
    egress  = map(list(string))
  }))
}

variable "bastion_host_sg_cidr_blocks" {
  type = list(object({
    name    = string
    ingress = map(list(string))
    egress  = map(list(string))
  }))
}

variable "request_forward_sg_cidr_blocks" {
  type = list(object({
    name    = string
    ingress = map(list(string))
    egress  = map(list(string))
  }))
}

variable "backend_sg_cidr_blocks" {
  type = list(object({
    name    = string
    ingress = map(list(string))
    egress  = map(list(string))
  }))
}

variable "database_sg_cidr_blocks" {
   type = list(object({
    name    = string
    ingress = map(list(string))
    egress  = map(list(string))
  }))
}