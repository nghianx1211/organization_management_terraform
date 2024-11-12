output "bastion_host_security_group_id" {
  value = aws_security_group.bastion_host_security_group.id
}

output "frontend_security_group_id" {
  value = aws_security_group.frontend_security_group.id
}

output "backend_security_group_id" {
  value = aws_security_group.backend_security_group.id
}

output "database_security_group_id" {
  value = aws_security_group.database_security_group.id
}