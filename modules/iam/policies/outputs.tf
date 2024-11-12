output "ec2_put_get_s3_policy_arn" {
    value = aws_iam_policy.organization_management_dev_ec2_s3.arn
}

output "ec2_assume_role_policy_document" {
  value = data.aws_iam_policy_document.ec2_assume_role.json
}