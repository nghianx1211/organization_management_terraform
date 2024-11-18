resource "aws_db_subnet_group" "database_subnet_groups" {
    count       = length(var.databases)

    subnet_ids	= var.databases[count.index].subnet_group.subnet_ids

	tags = {
		Name = "${var.project_name}-${var.env}-${var.databases[count.index].subnet_group.name}"
        Environment = var.env
	}
}

resource "aws_db_instance" "database" {
    count                   = length(var.databases)

	db_name 				= var.databases[count.index].database_info.db_name
	identifier 				= var.databases[count.index].database_info.identifier 
	engine 					= var.databases[count.index].database_info.engine
	engine_version 			= var.databases[count.index].database_info.engine_version
	instance_class 			= var.databases[count.index].database_info.instance_class
	allocated_storage 		= var.databases[count.index].database_info.allocated_storage
	username 				= var.databases[count.index].database_info.username
	password 				= var.databases[count.index].database_info.password

	vpc_security_group_ids 	= var.databases[count.index].database_info.security_group_ids
	db_subnet_group_name 	= aws_db_subnet_group.database_subnet_groups[count.index].name
	skip_final_snapshot 	= var.databases[count.index].database_info.skip_final_snapshot 

	tags = {
		"Name" = "${var.project_name}-${var.env}-${var.databases[count.index].database_info.db_name}"
	}
}