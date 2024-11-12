# =============Frontend security group==============

resource "aws_security_group" "frontend_security_group" {
  	name        = var.security_group.frontend.name
  	description	= var.security_group.frontend.description
  	vpc_id      = var.vpc_id

	tags = {
		"Name" = "${var.vpc_name}-${var.security_group.frontend.name}"
	}
}

# Ingress
resource "aws_vpc_security_group_ingress_rule" "frontend_http" {
	security_group_id	= aws_security_group.frontend_security_group.id
	ip_protocol       	= "tcp"
	from_port         	= 80
	to_port           	= 80
	cidr_ipv4         	= "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "frontend_https" {
	security_group_id	= aws_security_group.frontend_security_group.id
	ip_protocol       	= "tcp"
	from_port         	= 443
	to_port           	= 443
	cidr_ipv4         	= "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "frontend_ssh" {
	security_group_id 	= aws_security_group.frontend_security_group.id
	ip_protocol 		= "tcp"
	from_port 			= 22
	to_port 			= 22
	cidr_ipv4 			= "${var.bastion_host_private_ip}/32"
}

#	Egress
resource "aws_vpc_security_group_egress_rule" "frontend_all_traffic" {
  security_group_id = aws_security_group.frontend_security_group.id
  ip_protocol 			= "-1"
	cidr_ipv4         = "0.0.0.0/0"
}

# ========== Security group for database===============

resource "aws_security_group" "database_security_group" {
	name        = var.security_group.database.name
	description	= var.security_group.database.description
	vpc_id      = var.vpc_id

	tags = {
		"Name" = "${var.vpc_name}-${var.security_group.database.name}"
	}
}

#	Ingress
resource "aws_vpc_security_group_ingress_rule" "database_ingress_postgresql" {
	security_group_id = aws_security_group.database_security_group.id
	ip_protocol 			= "tcp"
	from_port 				= 5432
	to_port 				= 5432
	cidr_ipv4 				= "10.0.129.0/24"
}

#	Egress
resource "aws_vpc_security_group_egress_rule" "database_egress_postgresql" {
	security_group_id	= aws_security_group.database_security_group.id
	ip_protocol 			= "tcp"
	from_port 				= 5432
	to_port 				= 5432
	cidr_ipv4 				= "10.0.129.0/24"
}

# ============ Security group for bastion host ======

resource "aws_security_group" "bastion_host_security_group" {
	name 		= var.security_group.bastion_host.name
	description = var.security_group.bastion_host.description
	vpc_id 		= var.vpc_id

	tags = {
		"Name" = "${var.vpc_name}-${var.security_group.bastion_host.name}"
	}
}

# Ingress
resource "aws_vpc_security_group_ingress_rule" "bastion_host_ingress_ssh" {
	security_group_id 	= aws_security_group.bastion_host_security_group.id
	ip_protocol 		= "tcp"
	from_port 			= 22
	to_port 			= 22
	cidr_ipv4 			= "0.0.0.0/0"
}

# ============ Security group for backend ===========

resource "aws_security_group" "backend_security_group" {
	name       	= var.security_group.backend.name
	description	= var.security_group.backend.description
	vpc_id		= var.vpc_id

	tags = {
		"Name" = "${var.vpc_name}-${var.security_group.backend.name}"
	}
}

# Ingress
resource "aws_vpc_security_group_ingress_rule" "backend_http" {
	security_group_id 				= aws_security_group.backend_security_group.id
	ip_protocol 					= "tcp"
	from_port 						= 80
	to_port 						= 80
	referenced_security_group_id 	= aws_security_group.frontend_security_group.id
}

resource "aws_vpc_security_group_ingress_rule" "backend_https" {
	security_group_id 				= aws_security_group.backend_security_group.id
	ip_protocol 					= "tcp"
	from_port 						= 443
	to_port 						= 443
	referenced_security_group_id 	= aws_security_group.frontend_security_group.id
}

resource "aws_vpc_security_group_ingress_rule" "backend_ssh" {
	security_group_id 		= aws_security_group.backend_security_group.id
	ip_protocol 			= "tcp"
	from_port 				= 22
	to_port 				= 22
	cidr_ipv4 				= "${var.bastion_host_private_ip}/32"
}

resource "aws_vpc_security_group_ingress_rule" "backend_postgresql" {
	security_group_id 				= aws_security_group.backend_security_group.id
	from_port 						= 5432
	to_port 						= 5432
	ip_protocol 					= "tcp"
	referenced_security_group_id 	= aws_security_group.database_security_group.id
}

# Egress
resource "aws_vpc_security_group_egress_rule" "backend_all_traffic" {
	security_group_id 	= aws_security_group.backend_security_group.id
	ip_protocol 		= "-1"
	cidr_ipv4 			= "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "backend_postgresql" {
	security_group_id 				= aws_security_group.backend_security_group.id
	ip_protocol 					= "tcp"
	from_port 						= 5432
	to_port 						= 5432
	referenced_security_group_id 	= aws_security_group.database_security_group.id
}