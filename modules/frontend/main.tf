data "aws_ami" "frontend" {
  most_recent 	= true
  owners 		= var.frontend.owners

  filter {
    name 	= "name"
    values 	= var.frontend.ami_names
  }

	filter {
		name 	= "root-device-type"
		values 	= var.frontend.root_device_types
	}

	filter {
		name 	= "virtualization-type"
		values 	= var.frontend.virtualization_types
	}
}

resource "aws_instance" "frontend" {
	instance_type 				= var.frontend.instance_type
	ami 						= data.aws_ami.frontend.id
	vpc_security_group_ids		= var.frontend_security_group_ids
	subnet_id 					= var.subnets.public_subnets[0].id
	associate_public_ip_address = true

	tags = {
		"Name" = var.frontend.frontend_name
	}
}