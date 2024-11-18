output "frontend_instances_cidr_blocks" {
  value = [for instance in aws_instance.frontends : "${instance.private_ip}/32"]
}

output "bastion_host_instances_cidr_blocks" {
  value = [for instance in aws_instance.bastion_hosts : "${instance.private_ip}/32"]
}

output "request_forwarder_instances_cidr_blocks" {
  value = [for instance in aws_instance.request_forwarders : "${instance.private_ip}/32"]
}

output "backend_instances_cidr_blocks" {
  value = [for instance in aws_instance.backends : "${instance.private_ip}/32"]
}

output "ec2_instances_arns" {
  value = concat(
      [for instance in aws_instance.frontends : instance.arn],
      [for instance in aws_instance.backends : instance.arn],
      [for instance in aws_instance.bastion_hosts : instance.arn],
      [for instance in aws_instance.request_forwarders : instance.arn]
    )
}

