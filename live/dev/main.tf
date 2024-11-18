
provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "../../modules/vpc"

  project_name = local.project_name
  env = local.env

  vpc_cidr_block      = "12.0.0.0/16"
  availability_zones  = ["us-east-1a", "us-east-1b"]
  public_subnets      = ["12.0.1.0/24", "12.0.2.0/24"]
  private_subnets     = ["12.0.3.0/24", "12.0.4.0/24"]

  region = "us-east-1"
  enable_s3_enpoint = false
}


module "instances" {
  source = "../../modules/instances"

  project_name  = local.project_name
  env           = local.env

  frontend_instances          = local.frontend_instances
  bastion_host_instances      = local.bastion_host_instances
  request_forwarder_instances = local.request_forwarder_instances
  backend_instances           = local.backend_instances
  backend_assume_role_name    = module.iam.backend_assume_role_name
}


module "security_groups" {
  source = "../../modules/security_group"

  project_name  = local.project_name
  env           = local.env
  vpc_id        = module.vpc.vpc_id

  frontend_sg_cidr_blocks         = local.frontend_sg_cidr_blocks
  backend_sg_cidr_blocks          = local.backend_sg_cidr_blocks
  bastion_host_sg_cidr_blocks     = local.bastion_host_sg_cidr_blocks
  request_forward_sg_cidr_blocks  = local.request_forwarder_sg_cidr_blocks
  database_sg_cidr_blocks         = local.database_sg_cidr_blocks
}

module "databases" {
  source = "../../modules/database"

  project_name  = local.project_name
  env           = local.env

  databases = local.databases
}

module "s3" {
  source = "../../modules/s3"

  project_name  = local.project_name
  env           = local.env

  s3_buckets = [ "organizationmanagementfiles3" ]
}

module "iam" {
  source = "../../modules/iam"

  project_name  = local.project_name
  env           = local.env

  dev_policy_resources = local.dev_policy_resources
  devops_policy_resources =  local.devops_policy_resources
  backend_policy_resources = local.backend_policy_resources
}

# security group rule
locals {
  # frontend
  frontend_sg_cidr_blocks = [
    {
      name = "1a"
      ingress = {
        "http"  = ["0.0.0.0/0"]
        "https" = ["0.0.0.0/0"]
        "ssh"   = [module.instances.bastion_host_instances_cidr_blocks[0]]
      }
      egress = {
        "all_trafic" = ["0.0.0.0/0"]
      }
  }
  ]

  # bastion host
  bastion_host_sg_cidr_blocks = [
    {
      name = "1a"
      ingress = {
        "ssh" = ["0.0.0.0/0"]
      }
      egress = {
        "all_trafic" = ["0.0.0.0/0"]
      }
    }
  ]

  # request forwarder
  request_forwarder_sg_cidr_blocks = [
    {
      name = "1a"
      ingress = {
        "http"  = ["0.0.0.0/0"]
        "https" = ["0.0.0.0/0"]
        "ssh"   = [module.instances.bastion_host_instances_cidr_blocks[0]]
      }
      egress = {
        "all_trafic" = ["0.0.0.0/0"]
      }
    }
  ]

  backend_sg_cidr_blocks = [
    {
      name = "1a"
      ingress = {
        "http"  = [module.instances.request_forwarder_instances_cidr_blocks[0]]
        "https" = [module.instances.request_forwarder_instances_cidr_blocks[0]]
        "ssh"   = [module.instances.bastion_host_instances_cidr_blocks[0]]
      }
      egress = {
        "all_trafic" = ["0.0.0.0/0"]
      }
    }
  ]

  database_sg_cidr_blocks = [
    {
      name = "1a"
      ingress = {
        "postgresql" = [module.instances.backend_instances_cidr_blocks[0]]
      }
      egress = {
        "postgresql" = [module.instances.backend_instances_cidr_blocks[0]]
      }
    }
  ]
}

# Define general information
locals {
  project_name = "organization_management"
  env          = "dev"
}

#### Define instances
locals {
  # Define frontend instances
  frontend_instances = {
    ami = {
       owners                 = [ "099720109477" ]
        names                  = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    instances_info = [
      {
        instance_type           = "t2.micro"
        security_group_ids      = [module.security_groups.frontend_security_group_ids[0]]
        subnet_id               = module.vpc.public_subnet_ids[0]
        name                    = "frontend-1a"
      },
    ]
  }
 

  # bastion_host instances
  bastion_host_instances = {
    ami = {
       owners                 = [ "099720109477" ]
        names                  = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    instances_info = [
      {
        instance_type           = "t2.micro"
        security_group_ids      = [module.security_groups.bastion_host_security_group_ids[0]]
        subnet_id               = module.vpc.public_subnet_ids[0]
        name                    = "bastion_host-1a"
      }
    ]
  }

  # Define request forwarder instances
    request_forwarder_instances = {
      ami = {
        owners                 = [ "099720109477" ]
        names                  = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
      }
      instances_info = [
        {
          instance_type           = "t2.micro"
          security_group_ids      = [module.security_groups.request_forwarder_security_group_ids[0]]
          subnet_id               = module.vpc.public_subnet_ids[0]
          name                    = "request-forward-1a"
        }
      ]
  }

   # Define backend instances
  backend_instances = {
    ami = {
       owners                 = [ "099720109477" ]
        names                  = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    instances_info = [
      {
        instance_type           = "t2.micro"
        security_group_ids      = [module.security_groups.backend_security_group_ids[0]]
        subnet_id               = module.vpc.private_subnet_ids[0]
        name                    = "backend-1a"
      }
    ]
  }

}

# Define database
locals {
  databases = [{
    subnet_group = {
      subnet_ids = module.vpc.private_subnet_ids
      name       = "postgresql"
    }
    database_info = {
      db_name           = "postgresql"
      identifier        = "organization-management-database"
      engine            = "postgres"
      engine_version    = "16.3"
      instance_class    = "db.t3.micro"
      allocated_storage = 20
      username          = "postgres"
      password          = "postgres"

      security_group_ids  = [module.security_groups.database_security_group_ids[0]]
      skip_final_snapshot = true
    }
  }]
}

# Define resource for policy
locals {
  dev_policy_resources = {
    "ec2" = ["*"]
    "s3" = module.s3.s3_buckets_arns
  }

  devops_policy_resources = {
    "ec2" = module.instances.ec2_instances_arns
    "s3" = module.s3.s3_buckets_arns
  }

  backend_policy_resources = {
    "s3" = module.s3.s3_buckets_arns
  }
}