# Create VPC
resource "aws_vpc" "vpc" {
	cidr_block = var.vpc.cidr_block

	tags = {
		"Name" = "${var.vpc.vpc_name}-vpc"
	}
}

# Create subnet
resource "aws_subnet" "public_subnets" {
	count 			= length(var.vpc.availability_zones)

	vpc_id            = aws_vpc.vpc.id
	cidr_block        = var.vpc.public_subnets[count.index]
	availability_zone = var.vpc.availability_zones[count.index % length(var.vpc.availability_zones)]

	tags = {
		"Name" = "public-subnet-${var.vpc.availability_zones[count.index % length(var.vpc.availability_zones)]}"
	}
}

resource "aws_subnet" "private_subnets" {
	count             = length(var.vpc.availability_zones)

	vpc_id            = aws_vpc.vpc.id
	cidr_block        = var.vpc.private_subnets[count.index]
	availability_zone = var.vpc.availability_zones[count.index % length(var.vpc.availability_zones)]

	tags = {
		"Name" = "private-subnet-${var.vpc.availability_zones[count.index % length(var.vpc.availability_zones)]}"
	}
}

locals {
	invalid_nat_gateway_subnet_ids = [
		for cidr in var.vpc.nat_gateway_subnets 
		: aws_subnet.public_subnets[try(index(var.vpc.public_subnets, cidr), -1)].id 
		if try(index(var.vpc.public_subnets, cidr), -1)  != -1
	]
}

# Create internet gateway
resource "aws_internet_gateway" "igw" {
  	vpc_id = aws_vpc.vpc.id
}

# Create nat gateway
resource "aws_eip" "nat" {
	count = length(local.invalid_nat_gateway_subnet_ids)
}

resource "aws_nat_gateway" "nat_gateways" {
	count = length(local.invalid_nat_gateway_subnet_ids)
	allocation_id = aws_eip.nat[count.index].id
	subnet_id     = local.invalid_nat_gateway_subnet_ids[count.index]
}


# Create route table
resource "aws_route_table" "public_route_table" {
	vpc_id = aws_vpc.vpc.id

	route {
		cidr_block  = "0.0.0.0/0"
		gateway_id  = aws_internet_gateway.igw.id
	}

	tags = {
		"Name"  = "${var.vpc.vpc_name}-public-route-table"
	}
}

# Create private route table without nat gateway
resource "aws_route_table" "private_route_table" {
	count = length(aws_nat_gateway.nat_gateways) == 0 ? 1 : 0
  	vpc_id = aws_vpc.vpc.id

	tags = {
		"Name"  = "${var.vpc.vpc_name}-private-route-table"
	}
}

# Create private route table with nat gateway
resource "aws_route_table" "private_route_tables" {
	count = length(aws_nat_gateway.nat_gateways)
  	vpc_id = aws_vpc.vpc.id

	route {
		cidr_block  = "0.0.0.0/0"
		gateway_id  = aws_nat_gateway.nat_gateways[count.index].id
	}

	tags = {
		"Name"  = "${var.vpc.vpc_name}-private-route-table"
	}
}


# Add subnet to route table
resource "aws_route_table_association" "public_route_table_association" {
	count           = length(var.vpc.public_subnets)
	subnet_id       = aws_subnet.public_subnets[count.index].id
	route_table_id  = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_association" {
	count           = length(var.vpc.private_subnets)
	subnet_id       = aws_subnet.private_subnets[count.index].id
	route_table_id  = (length(aws_nat_gateway.nat_gateways) == length(var.vpc.private_subnets) 
						? aws_route_table.private_route_tables[count.index].id
						: length(aws_nat_gateway.nat_gateways) > 0 
						?  aws_route_table.private_route_tables[0].id 
						: aws_route_table.private_route_table[0].id
					)
}

# Create s3 endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
	count 			= (var.vpc.enable_s3_endpoint && length(aws_nat_gateway.nat_gateways) > 0 
						? length(aws_nat_gateway.nat_gateways)
        				: var.vpc.enable_s3_endpoint ? 1 : 0
					)
	vpc_id          = aws_vpc.vpc.id
	service_name    = "com.amazonaws.us-east-1.s3"
	route_table_ids = (length(aws_nat_gateway.nat_gateways) > 0 
						? [ aws_route_table.private_route_tables[count.index].id ] 
						: [ aws_route_table.private_route_table[count.index].id ]
					)

	tags = {
		"Name" = "s3-endpoint"
	}
}