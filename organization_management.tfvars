vpc = {
    vpc_name            = "organization_management"
    cidr_block          = "12.0.0.0/16"
    availability_zones  = ["us-east-1a", "us-east-1b"]
    public_subnets      = ["12.0.1.0/24", "12.0.65.0/24"]
    private_subnets     = ["12.0.129.0/24", "12.0.195.0/24"]
    nat_gateway_subnets = []
    enable_s3_endpoint  = true
}

security_group = {
    frontend = {
        name        = "organization_mananagement-frontend"
        description = "Security group for frontend ec2 us-east 1a"
    }
    backend = {
        name        = "organization_mananagement-backend"
        description = "Security_group for backend ec2 us-east-1a"
    }
    bastion_host = {
        name        = "organization_mananagement-bast_host"
        description = "Security_group for backend ec2 us-east-1a"
    }
    database = {
        name        = "organization_mananagement-database"
        description = "Security_group for database"
    }
}

bastion_host = {
    owners                  = [ "099720109477" ]
    ami_names               = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    root_device_types       = [ "ebs" ]
    virtualization_types    = [ "hvm" ]
    instance_type           = "t2.micro"
    bastion_host_name       = "bastion-host"
}

frontend = {
    owners                  = [ "099720109477" ]
    ami_names               = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    root_device_types       = [ "ebs" ]
    virtualization_types    = [ "hvm" ]
    instance_type           = "t2.micro"
    frontend_name           = "frontend-1a"
}

backend = {
    owners                  = [ "099720109477" ]
    ami_names               = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    root_device_types       = [ "ebs" ]
    virtualization_types    = [ "hvm" ]
    instance_type           = "t2.micro"
    backend_name            = "backend-1a"
}

database = {
    db_name                     = "organizationmanagementdatabase"
    identifier                  = "organizationmanagementdatabase"
    instance_class              = "db.t3.micro"
    engine_version              = "16.3"
    allocated_storage           = 20
    username                    = "postgress"
    password                    = "postgress"
    database_subnet_group_name  = "database_subnet_group"
}

s3 = {
    bucket_name = "organizationmangements3bucket"
}