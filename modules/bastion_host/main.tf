data "aws_ami" "bastion_host" {
	most_recent = true
	owners 		= var.bastion_host.owners

	filter {
		name 	= "name"
		values 	= var.bastion_host.ami_names
	}

	filter {
		name 	= "root-device-type"
		values 	= var.bastion_host.root_device_types
	}

	filter {
		name 	= "virtualization-type"
		values 	= var.bastion_host.virtualization_types
	}
}

resource "aws_instance" "bastion_host" {
	instance_type 				= var.bastion_host.instance_type
	ami 						= data.aws_ami.bastion_host.id
	vpc_security_group_ids		= var.bastion_host_security_group_ids
	subnet_id 					= var.subnets.public_subnets[0].id
	associate_public_ip_address = true

	tags = {
		"Name" = var.bastion_host.bastion_host_name
	}
}