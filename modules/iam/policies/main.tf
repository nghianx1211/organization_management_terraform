# Policy for dev
data "aws_iam_policy_document" "organization_management_dev_dev_ec2_s3" {
	statement {
		effect 		= "Allow"
		actions 	= [ 
				"ec2:DescribeInstances"
		 	]
		resources 	= var.organization_management_dev_dev_ec2_resources
	}

	statement {
		effect 		= "Allow"
		actions 	= [
			"s3:GetObject",
			"s3:ListBucket"
		]
		resources 	= var.organization_management_dev_dev_s3_resources
	}
}

# Policy for devops
data "aws_iam_policy_document" "organization_management_dev_devops_ec2_s3" {
  statement {
    effect 		= "Allow"
    actions 	=	[  
        "ec2:DescribeInstances",
        "ec2:DescribeInstanceTypes",
        "ec2:DescribeInstanceStatus",
        "ec2:DescribeVolumes"
     ]
    resources 	= [ "*" ]
  }

	statement {
		effect 		= "Allow"
		actions 	= [  
			"ec2:AttachVolume",
			"ec2:AuthorizeSecurityGroupIngress",
			"ec2:AssociateIamInstanceProfile",
			"ec2:AttachNetworkInterface",
			"ec2:CreateVolume",
			"ec2:CreateKeyPair",
			"ec2:CreateImage",
			"ec2:CreateTags",
			"ec2:CreateSecurityGroup",
			"ec2:CreateSnapshot",
			"ec2:DeleteSnapshot",
			"ec2:DeleteTags",
			"ec2:DescribeInstanceAttribute",
			"ec2:DeleteVolume",
			"ec2:DeleteKeyPair",
			"ec2:DescribeNetworkInterfaces",
			"ec2:DescribeVpcs",
			"ec2:DescribeSubnets",
			"ec2:DescribeKeyPairs",
			"ec2:DescribeSnapshots",
			"ec2:DetachVolume",
			"ec2:ImportKeyPair",
			"ec2:ModifyInstanceAttribute",
			"ec2:ModifyVolume",
			"ec2:TerminateInstances",
			"ec2:RunInstances",
			"ec2:StartInstances",
			"ec2:StopInstances"
		]
		resources 	= var.organization_management_dev_devops_ec2_resources
	}

	statement {
		effect 	= "Allow"
		actions = [  
			"s3:CreateBucket",
			"s3:DeleteObject",
			"s3:DeleteBucket",
			"s3:DeleteObjectVersion",
			"s3:ListBucketVersions",
			"s3:GetBucketLogging",
			"s3:GetObjectAcl",
			"s3:GetObjectTagging",
			"s3:GetBucketPublicAccessBlock",
			"s3:GetBucketAcl",
			"s3:GetBucketNotification",
			"s3:GetObject",
			"s3:ListBucket",
			"s3:PutBucketAcl",
			"s3:PutObjectTagging",
			"s3:PutObjectAcl",
			"s3:PutBucketNotification",
			"s3:PutBucketLogging",
			"s3:ReplicateObject",
			"s3:RestoreObject",
			"s3:ReplicateDelete"
		]
    resources = var.organization_management_dev_devops_s3_resources
  }
}

data "aws_iam_policy_document" "organization_management_dev_ec2_s3" {
	statement {
		effect 		= "Allow"
		actions 	= [
			"s3:GetObject",
			"s3:PutObject"
		]
		resources 	= var.organization_management_dev_ec2_s3_resources
	}
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
	effect 	= "Allow"
	actions = [ "sts:AssumeRole" ]
	principals {
	  type = "Service"
	  identifiers = ["ec2.amazonaws.com"]
	}
  }
}


# Resources
resource "aws_iam_policy" "organization_management_dev_dev_ec2_s3" {
	name 		= "organization_management_dev_dev_ec2_s3"
	description = "policy for dev in organization mangement project"
	policy 		= data.aws_iam_policy_document.organization_management_dev_dev_ec2_s3.json
}


resource "aws_iam_policy" "organization_management_dev_devops_ec2_s3" {
	name 		= "organization_management_dev_devops_ec2_s3"
	description = "policy for devops in organization mangement project"
	policy 		= data.aws_iam_policy_document.organization_management_dev_devops_ec2_s3.json
}

resource "aws_iam_policy" "organization_management_dev_ec2_s3" {
	name 		= "organization_management_dev_ec2_s3"
	description = "Policy allowing EC2 to put and get objects from specified s3"
	policy 		= data.aws_iam_policy_document.organization_management_dev_ec2_s3.json
}

locals {
	dev_policies_arns = {
    "dev_ec2_s3" = aws_iam_policy.organization_management_dev_dev_ec2_s3.arn
  }

  devops_policies_arns = {
    "devops_ec2_s3" = aws_iam_policy.organization_management_dev_devops_ec2_s3.arn
  }
}

resource "aws_iam_group_policy_attachment" "dev_attachment" {
	for_each 	= local.dev_policies_arns
	group 		= "dev"
	policy_arn 	= each.value
}

resource "aws_iam_group_policy_attachment" "devops_attachment" {
	for_each 	= local.devops_policies_arns
	group 		= "devops"
	policy_arn 	= each.value
}