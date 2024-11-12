variable "vpc" {
  type = object({
    vpc_name = string
    cidr_block = string
    availability_zones = list(string)
    public_subnets     = list(string)
    private_subnets    = list(string)
    nat_gateway_subnets = list(string)
    enable_s3_endpoint = bool
  })
}