output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnets" {
  value = {
    public_subnets  = [for subnet in aws_subnet.public_subnets : subnet]
    private_subnets = [for subnet in aws_subnet.private_subnets : subnet]
  }
}

output "vpc_name" {
  value = var.vpc.vpc_name
}