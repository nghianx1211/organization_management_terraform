data "aws_ami" "backend" {
	most_recent = true
	owners 		= var.backend.owners

	filter {
		name 	= "name"
		values 	= var.backend.ami_names
	}

	filter {
		name 	= "root-device-type"
		values 	= var.backend.root_device_types
	}

	filter {
		name 	= "virtualization-type"
		values 	= var.backend.virtualization_types
	}
}

resource "aws_iam_instance_profile" "backend_ec2_put_get_s3" {
	name = "backend_ec2_put_get_s3"
	role = var.ec2_put_get_s3_role
}

resource "aws_instance" "backend" {
	instance_type 			= var.backend.instance_type
	ami 					= data.aws_ami.backend.id
	vpc_security_group_ids	= var.backend_security_group_ids
	subnet_id 				= var.subnets.private_subnets[0].id
	iam_instance_profile	= aws_iam_instance_profile.backend_ec2_put_get_s3.name
	tags = {
		"Name" = var.backend.backend_name
	}
}