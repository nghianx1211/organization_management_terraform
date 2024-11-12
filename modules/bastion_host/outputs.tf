output "instance_private_ip" {
	value = aws_instance.bastion_host.private_ip
}

output "bastion_host_arn" {
  value = aws_instance.bastion_host.arn
}