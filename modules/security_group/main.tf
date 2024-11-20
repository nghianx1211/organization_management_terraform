
# ================= Frontend sg ====================
resource "aws_security_group" "frontends_sg" {
    for_each = {for cidr_blocks in var.frontend_sg_cidr_blocks : cidr_blocks.name => cidr_blocks}

    name    = "${var.project_name}-${var.env}-${each.value.name}-frontend-sg"
    vpc_id  = var.vpc_id

    # ingress
    ingress {
        description = "Allow HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["http"]
    }

    ingress {
        description = "Allow HTTPS access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["https"]
    }
    
    ingress {
        description = "Allow SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["ssh"]
    }

    # egress
    egress {
        description = "Allow All traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }

    tags = {
        Name        = "${var.project_name}-${var.env}-${each.value.name}-frontend-security_group"
        Environment = var.env
    }
}


# ================= Bastion host sg ====================
resource "aws_security_group" "bastion_hosts_sg" {
    for_each = {for cidr_blocks in var.bastion_host_sg_cidr_blocks : cidr_blocks.name => cidr_blocks}

    name    = "${var.project_name}-${var.env}-${each.value.name}-bastion_host-sg"
    vpc_id  = var.vpc_id

    # ingress
    ingress {
        description = "Allow SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # egress
    egress {
        description = "Allow All traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }

    tags = {
        Name        = "${var.project_name}-${var.env}-${each.value.name}-bastion_host-security_group"
        Environment = var.env
    }
}


# ================= request forwarder sg ====================
resource "aws_security_group" "request_forwarders_sg" {
    for_each = {for cidr_blocks in var.request_forward_sg_cidr_blocks : cidr_blocks.name => cidr_blocks}

    name    = "${var.project_name}-${var.env}-${each.value.name}-request_forwarder-sg"
    vpc_id  = var.vpc_id

    # ingress
    ingress {
        description = "Allow HTTPS access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["https"]
    }

    ingress {
        description = "Allow HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["http"]
    }

    ingress {
        description = "Allow custom tcp access"
        from_port   = 8081
        to_port     = 8081
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["http"]
    }

    ingress {
        description = "Allow SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["ssh"]
    }

    # egress
    egress {
        description = "Allow All traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }

    tags = {
        Name        = "${var.project_name}-${var.env}-${each.value.name}-request_forwarder-security_group"
        Environment = var.env
    }
}


# ================ Backend sg ==================
resource "aws_security_group" "backends_sg" {
    for_each = {for cidr_blocks in var.backend_sg_cidr_blocks : cidr_blocks.name => cidr_blocks}

    name    = "${var.project_name}-${var.env}-${each.value.name}-backend-sg"
    vpc_id  = var.vpc_id

    # ingress
    ingress {
        description = "Allow HTTPS access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["https"]
    }

    ingress {
        description = "Allow HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["http"]
    }

    ingress {
        description = "Allow custom tcp access"
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["http"]
    }

    ingress {
        description = "Allow SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["ssh"]
    }

    # egress
    egress {
        description = "Allow All traffic"
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }

    tags = {
        Name        = "${var.project_name}-${var.env}-${each.value.name}-backend-security_group"
        Environment = var.env
    }
}


# ================= database sg ==================
resource "aws_security_group" "databases_sg" {
    for_each = {for cidr_blocks in var.database_sg_cidr_blocks : cidr_blocks.name => cidr_blocks}

    name    = "${var.project_name}-${var.env}-${each.value.name}-database-sg"
    vpc_id  = var.vpc_id

    # ingress
    ingress {
        description = "Allow Posgresql access"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = each.value.ingress["postgresql"]
    }

    # egress
    egress {
        description = "Allow Posgresql access"
        from_port   = 5432
        to_port     = 5432
        protocol    = "tcp"
        cidr_blocks = each.value.egress["postgresql"]
    }

    tags = {
        Name         = "${var.project_name}-${var.env}-${each.value.name}-database-security_group"
        Environment  = var.env
    }
}