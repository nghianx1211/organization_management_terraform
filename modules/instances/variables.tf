variable "frontend_instances" {
  type = object({
    ami = object({
      owners                = set(string)
      names                 = set(string)
    })
    instances_info = list(object({
      instance_type           = string
      name                    = string
      subnet_id               = string
      security_group_ids      = set(string)
    }))
  })
}

variable "bastion_host_instances" {
  type = object({
    ami = object({
      owners                = set(string)
      names                 = set(string)
    })
    instances_info = list(object({
      instance_type           = string
      name                    = string
      subnet_id               = string
      security_group_ids      = set(string)
    }))
  })
}

variable "request_forwarder_instances" {
  type = object({
    ami = object({
      owners                = set(string)
      names                 = set(string)
    })
    instances_info = list(object({
      instance_type           = string
      name                    = string
      subnet_id               = string
      security_group_ids      = set(string)
    }))
  })
}

variable "backend_instances" {
  type = object({
    ami = object({
      owners                = set(string)
      names                 = set(string)
    })
    instances_info = list(object({
      instance_type           = string
      name                    = string
      subnet_id               = string
      security_group_ids      = set(string)
    }))
  })
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "backend_assume_role_name" {
  type = string
}