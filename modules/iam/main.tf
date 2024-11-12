module "policies" {
  source = "./policies"
  organization_management_dev_dev_ec2_resources = var.organization_management_dev_dev_ec2_resources
  organization_management_dev_dev_s3_resources = var.organization_management_dev_dev_s3_resources
  organization_management_dev_devops_ec2_resources = var.organization_management_dev_devops_ec2_resources
  organization_management_dev_devops_s3_resources = var.organization_management_dev_devops_s3_resources
  organization_management_dev_ec2_s3_resources  = var.organization_management_dev_ec2_s3_resources
}

module "roles" {
  source = "./roles"
  ec2_assume_role_policy_document = module.policies.ec2_assume_role_policy_document
  ec2_put_get_s3_policy_arn = module.policies.ec2_put_get_s3_policy_arn
}