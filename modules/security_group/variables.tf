variable "vpc_id" {
  type = string
}

variable "bastion_host_private_ip" {
  type = string
}

variable "security_group" {
  type = object({
    frontend = object({
      name = string
      description = string
    })
    backend = object({
      name = string
      description = string
    })
    bastion_host = object({
      name = string
      description = string
    })
    database = object({
      name = string
      description = string
    })
  })
}

variable "vpc_name" {
  type = string
}