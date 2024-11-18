module "vpc" {
  	source = "terraform-aws-modules/vpc/aws"

  	name				= "${var.project_name}-vpc"
	cidr 				= var.vpc_cidr_block

	azs 				= var.availability_zones
	private_subnets 	= var.private_subnets
	public_subnets 		= var.public_subnets

	
	tags = {
		Terraform 	= "true"
		Environment = var.env
	}
}

resource "aws_vpc_endpoint" "s3" {
	count 				= var.enable_s3_enpoint ? 1 : 0
	vpc_id				= module.vpc.vpc_id
	vpc_endpoint_type 	= "Gateway"
	service_name 		= "com.amazonaws.${var.region}.s3"
	route_table_ids 	= module.vpc.private_route_table_ids

	tags = {
	  Name = "${var.project_name}-${var.env}-s3-vpc_endpoint"
	}
}