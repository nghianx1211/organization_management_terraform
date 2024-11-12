provider "aws" {
  	region 	= "us-east-1"
 	alias   = "source"
}

module "vpc" {
  	source  = "./modules/vpc"
  	vpc 	= var.vpc
}

module "security_group" {
	source                  	= "./modules/security_group"
	vpc_id                  	= module.vpc.vpc_id
	bastion_host_private_ip 	= module.bastion_host.instance_private_ip
	security_group 				= var.security_group
	vpc_name 					= module.vpc.vpc_name
}

module "bastion_host" {
  source                          	= "./modules/bastion_host"

  bastion_host_security_group_ids 	= [module.security_group.bastion_host_security_group_id]
  subnets                         	= module.vpc.subnets
  bastion_host 						= var.bastion_host
}

module "frontend" {
  source                        = "./modules/frontend"

  frontend_security_group_ids   = [module.security_group.frontend_security_group_id]
  subnets                       = module.vpc.subnets
  frontend 						= var.frontend
}

module "backend" {
  source                      	= "./modules/backend"

  backend_security_group_ids  	= [module.security_group.backend_security_group_id]
  subnets                     	= module.vpc.subnets

  backend 						= var.backend
  ec2_put_get_s3_role = module.iam.ec2_put_get_s3_role
}

module "database" {
  source = "./modules/database"
  subnet_ids = [ for subnet in module.vpc.subnets.private_subnets : subnet.id]
  database_security_group_ids = [ module.security_group.database_security_group_id ]
  database = var.database
}

module "s3" {
  source = "./modules/s3"
  s3 = var.s3
}

module "iam" {
  source = "./modules/iam"
  organization_management_dev_dev_ec2_resources = ["*"]
  organization_management_dev_dev_s3_resources = [ module.s3.s3_arn]
  organization_management_dev_devops_ec2_resources = [
    module.frontend.frontend_arn,
    module.backend.backend_arn,
    module.bastion_host.bastion_host_arn
  ]
  organization_management_dev_devops_s3_resources = [ module.s3.s3_arn ]
  organization_management_dev_ec2_s3_resources    = [ module.s3.s3_arn ]
}