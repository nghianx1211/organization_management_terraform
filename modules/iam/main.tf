# ==================== policy for dev =========================
resource "aws_iam_policy" "dev" {
    name = "${var.project_name}-${var.env}-ec2-s3-dev_policy" 
    policy = jsonencode({
          Version = "2012-10-17",
          Statement = [
            {
                Effect = "Allow",
                Action = [
                  "ec2:DescribeInstances"
                ],
                Resource = "*"
            },
            {
              Effect = "Allow",
              Action = [
                  "s3:GetObject",
                  "s3:ListBucket"
              ],
              Resource = var.dev_policy_resources["s3"]
            }
          ]
      }
    )

    tags = {
      Name = "${var.project_name}-${var.env}-ec2-s3-dev_policy"
    }
}

resource "aws_iam_group_policy_attachment" "dev_attachment" {
    group = "dev"
    policy_arn = aws_iam_policy.dev.arn
}


# ===================== policy for devops
resource "aws_iam_policy" "devops" {
    name = "${var.project_name}-${var.env}-ec2-s3-devops_policy"
    policy = jsonencode({
          Version = "2012-10-17",
          Statement = [
            {
                Effect = "Allow",
                Action = [
                  "ec2:DescribeInstances",
                  "ec2:DescribeInstanceTypes",
                  "ec2:DescribeInstanceStatus",
                  "ec2:DescribeVolumes"
                ],
                Resource = ["*"]
            },
            {
              Effect = "Allow",
              Action = [
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
              ],
              Resource = var.devops_policy_resources["ec2"]
            },
            {
                Effect = "Allow",
                Action = [
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
                ],
                Resource = var.devops_policy_resources["s3"]
            }
          ]
      }
    )

    tags = {
      Name = "${var.project_name}-${var.env}-ec2-s3-devops_policy"
    }
}
resource "aws_iam_group_policy_attachment" "devops_attachment" {
  group = "devops"
  policy_arn = aws_iam_policy.devops.arn
}


# ================== attach assume role =============================
resource "aws_iam_policy" "backend" {
    name = "${var.project_name}-${var.env}-s3-backend_policy"
    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
            {
                Effect = "Allow",
                Action = [
                    "s3:GetObject",
                    "s3:ListBucket"
                ],
                Resource = var.backend_policy_resources["s3"]
            }
        ]
    }) 

    tags = {
      Name = "${var.project_name}-${var.env}-backend_policy"
    }
}

resource "aws_iam_role" "backend_assume_role" {
  name = "${var.project_name}-${var.env}-backend-assumerole"
  assume_role_policy = jsonencode({
        "Version": "2012-10-17",
        Statement = [
            {
            Effect = "Allow",
            Principal =  {
                Service = "ec2.amazonaws.com"
            },
            Action = "sts:AssumeRole"
            }
        ]
    })

  tags = {
    Name = "${var.project_name}-${var.env}-backend-assumerole"
  }
}

resource "aws_iam_role_policy_attachment" "backend_role" {
  policy_arn = aws_iam_policy.backend.arn
  role = aws_iam_role.backend_assume_role.name
}