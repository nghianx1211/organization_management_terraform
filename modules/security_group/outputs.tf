output "frontend_security_group_ids" {
    value = [for security_group in aws_security_group.frontends_sg : security_group.id]
}

output "bastion_host_security_group_ids" {
    value = [for security_group in aws_security_group.bastion_hosts_sg : security_group.id]
}

output "backend_security_group_ids" {
   value = [for security_group in aws_security_group.backends_sg : security_group.id]
}

output "database_security_group_ids" {
    value = [for security_group in aws_security_group.databases_sg : security_group.id]
}