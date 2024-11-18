# ============== Frontend =====================
data "aws_ami" "frontend" {
    most_recent = true
	owners 		= var.frontend_instances.ami.owners

	filter {
		name 	= "name"
		values 	= var.frontend_instances.ami.names
	}
}

resource "aws_instance" "frontends" {
	for_each = {for instance_info in var.frontend_instances.instances_info : instance_info.name => instance_info}
	
	ami 					= data.aws_ami.frontend.id
    instance_type           = each.value.instance_type
    vpc_security_group_ids  = each.value.security_group_ids
    subnet_id               = each.value.subnet_id

    tags = {
		Name = "${var.project_name}-${var.env}-${each.value.name}"
		Environment = var.env
	}
}


#================= Bastion host ======================
data "aws_ami" "bastion_host" {
    most_recent = true
	owners 		= var.bastion_host_instances.ami.owners

	filter {
		name 	= "name"
		values 	= var.bastion_host_instances.ami.names
	}
}


resource "aws_instance" "bastion_hosts" {
    for_each = {for instance_info in var.bastion_host_instances.instances_info : instance_info.name => instance_info}

	ami 					= data.aws_ami.bastion_host.id
    instance_type           = each.value.instance_type
    vpc_security_group_ids  = each.value.security_group_ids
    subnet_id               = each.value.subnet_id

    tags = {
		Name = "${var.project_name}-${var.env}-${each.value.name}"
		Environment = var.env
	}
}


# ================== Request forwarder =====================
data "aws_ami" "request_forwarder" {
    most_recent = true
	owners 		= var.request_forwarder_instances.ami.owners

	filter {
		name 	= "name"
		values 	= var.request_forwarder_instances.ami.names
	}
}



resource "aws_instance" "request_forwarders" {
  	for_each = {for instance_info in var.request_forwarder_instances.instances_info : instance_info.name => instance_info}

	ami 					= data.aws_ami.request_forwarder.id
    instance_type           = each.value.instance_type
    vpc_security_group_ids  = each.value.security_group_ids
    subnet_id               = each.value.subnet_id

    tags = {
		Name = "${var.project_name}-${var.env}-${each.value.name}"
		Environment = var.env
	}
}


#================= Backend ======================

data "aws_ami" "backend" {
    most_recent = true
	owners 		= var.backend_instances.ami.owners

	filter {
		name 	= "name"
		values 	= var.backend_instances.ami.names
	}
}

resource "aws_iam_instance_profile" "backend" {
  count = var.backend_assume_role_name != "" ? 1 : 0

  name = "profile"
  role = var.backend_assume_role_name
}

resource "aws_instance" "backends" {
 	for_each = {for instance_info in var.backend_instances.instances_info : instance_info.name => instance_info}

	ami 					= data.aws_ami.backend.id
    instance_type           = each.value.instance_type
    vpc_security_group_ids  = each.value.security_group_ids
    subnet_id               = each.value.subnet_id
	iam_instance_profile 	= aws_iam_instance_profile.backend[0].name != "" ? aws_iam_instance_profile.backend[0].name : null
    tags = {
		Name = "${var.project_name}-${var.env}-${each.value.name}"
		Environment = var.env
	}
}

