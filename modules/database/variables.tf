variable "subnet_ids" {
  type = set(string)
}

variable "database" {
    type 						= object({
		db_name 					= string
		identifier 					= string
		instance_class				= string
		engine_version 				= string
		allocated_storage 			= number
		username 					= string
		password 					= string
		database_subnet_group_name 	= string
  })

  	sensitive = true
}
variable "database_security_group_ids" {
  	type = set(string)
}