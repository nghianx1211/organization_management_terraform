variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "databases" {
    type = list(object({
    subnet_group = object({
        subnet_ids              = set(string)
        name = string
    })
    database_info = object({
        db_name 				    = string
        identifier 				= string
        engine 					= string
        engine_version 			= string
        instance_class 			= string
        allocated_storage 		= number
        username 				= string
        password 				= string

        security_group_ids 	= set(string)
        skip_final_snapshot 	= bool  
    })
    }))
}