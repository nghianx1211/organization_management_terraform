resource "aws_db_subnet_group" "database_subnet_group" {
	name 		= var.database.database_subnet_group_name
	subnet_ids	= var.subnet_ids

	tags = {
		Name = var.database.database_subnet_group_name
	}
}

resource "aws_db_instance" "postgresql" {
	db_name 				= var.database.db_name
	identifier 				= var.database.identifier 
	engine 					= "postgres"
	engine_version 			= var.database.engine_version
	instance_class 			= var.database.instance_class
	allocated_storage 		= var.database.allocated_storage
	username 				= var.database.username
	password 				= var.database.password

	vpc_security_group_ids 	= var.database_security_group_ids
	db_subnet_group_name 	= aws_db_subnet_group.database_subnet_group.name
	skip_final_snapshot 	= true 

	tags = {
		"Name" = "${var.database.db_name}postgresql"
	}
}