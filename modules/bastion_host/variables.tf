variable "bastion_host_security_group_ids" {
  type = set(string)
}

variable "subnets" {
  type = object(
    {
      public_subnets  = list(object(
        {
          id                              = string
          arn                             = string
          ipv6_cidr_block_association_id  = string
          owner_id                        = string
          tags_all                        = map(string)
        }
      ))
      private_subnets = list(object(
        {
          id                              = string
          arn                             = string
          ipv6_cidr_block_association_id  = string
          owner_id                        = string
          tags_all                        = map(string)
        }
      ))
    }
  )
}

variable "bastion_host" {
    type = object({
        owners                  = set(string) 
        ami_names               = set(string)
        root_device_types       = set(string)
        virtualization_types    = set(string)
        instance_type           = string
        bastion_host_name       = string
    })
}