variable "vpc" {
  type 					= object({
    vpc_name 			= string
    cidr_block 			= string
    availability_zones 	= list(string)
    public_subnets		= list(string)
    private_subnets 	= list(string)
    nat_gateway_subnets = list(string)
    enable_s3_endpoint 	= bool
  })
}

variable "security_group" {
  type = object({
    frontend 		= object({
      name 			= string
      description 	= string
    })
    backend 		= object({
      name 			= string
      description	= string
    })
    bastion_host 	= object({
      name 			= string
      description 	= string
    })
    database 		= object({
      name 			= string
      description 	= string
    })
  })
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

variable "frontend" {
    type = object({
        owners                  = set(string) 
        ami_names               = set(string)
        root_device_types       = set(string)
        virtualization_types    = set(string)
        instance_type           = string
        frontend_name       	= string
    })
}

variable "backend" {
    type = object({
        owners                  = set(string) 
        ami_names               = set(string)
        root_device_types       = set(string)
        virtualization_types    = set(string)
        instance_type           = string
        backend_name       		= string
    })
}

variable "database" {
  type = object({
    db_name 					= string
    identifier 					= string
    instance_class 				= string
    engine_version				= string
    allocated_storage 			= number
    username 					= string
    password 					= string
    database_subnet_group_name 	= string
  })

  sensitive = true
}

variable "s3" {
  type 			= object({
    bucket_name = string
  })
}